package db

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

// Connect создаёт пул соединений pgx и проверяет доступность базы.
func Connect(ctx context.Context, databaseURL string) (*pgxpool.Pool, error) {
	cfg, err := pgxpool.ParseConfig(databaseURL)
	if err != nil {
		return nil, fmt.Errorf("parse database url: %w", err)
	}
	cfg.MaxConns = 10
	pool, err := pgxpool.NewWithConfig(ctx, cfg)
	if err != nil {
		return nil, fmt.Errorf("create pool: %w", err)
	}
	checkCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()
	if err := pool.Ping(checkCtx); err != nil {
		pool.Close()
		return nil, fmt.Errorf("ping database: %w", err)
	}
	return pool, nil
}

// RunMigrations применяет каждый .sql из каталога ровно один раз.
// Учёт выполненного ведётся в таблице schema_migrations.
func RunMigrations(ctx context.Context, pool *pgxpool.Pool, dir string) (int, error) {
	if _, err := pool.Exec(ctx,
		`CREATE TABLE IF NOT EXISTS schema_migrations (
			version TEXT PRIMARY KEY,
			applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`); err != nil {
		return 0, fmt.Errorf("create schema_migrations: %w", err)
	}
	entries, err := os.ReadDir(dir)
	if err != nil {
		return 0, fmt.Errorf("read migrations dir: %w", err)
	}
	files := make([]string, 0, len(entries))
	for _, entry := range entries {
		if !entry.IsDir() && strings.HasSuffix(entry.Name(), ".sql") {
			files = append(files, entry.Name())
		}
	}
	sort.Strings(files)

	applied := 0
	for _, name := range files {
		var exists bool
		if err := pool.QueryRow(ctx,
			`SELECT EXISTS(SELECT 1 FROM schema_migrations WHERE version = $1)`, name).Scan(&exists); err != nil {
			return applied, fmt.Errorf("check migration %s: %w", name, err)
		}
		if exists {
			continue
		}
		content, err := os.ReadFile(filepath.Join(dir, name))
		if err != nil {
			return applied, fmt.Errorf("read %s: %w", name, err)
		}
		tx, err := pool.Begin(ctx)
		if err != nil {
			return applied, fmt.Errorf("begin %s: %w", name, err)
		}
		if _, err := tx.Exec(ctx, string(content)); err != nil {
			_ = tx.Rollback(ctx)
			return applied, fmt.Errorf("exec %s: %w", name, err)
		}
		if _, err := tx.Exec(ctx,
			`INSERT INTO schema_migrations (version) VALUES ($1)`, name); err != nil {
			_ = tx.Rollback(ctx)
			return applied, fmt.Errorf("mark %s: %w", name, err)
		}
		if err := tx.Commit(ctx); err != nil {
			return applied, fmt.Errorf("commit %s: %w", name, err)
		}
		applied++
	}
	return applied, nil
}
