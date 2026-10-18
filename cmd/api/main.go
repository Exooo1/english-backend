package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"english-backend/internal/config"
	"english-backend/internal/db"
	"english-backend/internal/handlers"
	"english-backend/internal/router"

	"github.com/joho/godotenv"
)

func main() {
	_ = godotenv.Load()
	cfg := config.LoadConfig(os.Getenv)
	ctx := context.Background()

	pool, err := db.Connect(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("database connection failed: %v. Check DB_HOST/DB_PORT and that Postgres is running.", err)
	}
	defer pool.Close()

	migrationDir := "migrations"
	if _, statErr := os.Stat(migrationDir); statErr == nil {
		applied, err := db.RunMigrations(ctx, pool, migrationDir)
		if err != nil {
			log.Printf("migration warning: %v", err)
		} else {
			log.Printf("migrations applied: %d", applied)
		}
	}

	api := handlers.NewAPI(pool)
	handler := router.Handler(api)

	addr := ":" + cfg.Port
	fmt.Printf("English backend listening on http://localhost%s\n", addr)
	if err := http.ListenAndServe(addr, handler); err != nil {
		log.Fatalf("server failed: %v", err)
	}
}
