package handlers

import (
	"context"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"unicode"

	"english-backend/internal/models"
)

// ListWords handles GET /api/words?search=&limit=&offset=
func (a *API) ListWords(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	search := strings.TrimSpace(q.Get("search"))
	limit, hasLimit := parseLimit(q.Get("limit"))
	offset := parseOffset(q.Get("offset"))

	sql := `SELECT id, english, translation, example, meaning, is_favorite, created_at, updated_at FROM words WHERE 1=1`
	args := []any{}
	if search != "" {
		sql += " AND (english ILIKE $1 OR translation ILIKE $1)"
		args = append(args, "%"+search+"%")
	}
	sql += " ORDER BY created_at DESC"
	if hasLimit {
		args = append(args, limit)
		sql += fmt.Sprintf(" LIMIT $%d", len(args))
	}
	if offset > 0 {
		args = append(args, offset)
		sql += fmt.Sprintf(" OFFSET $%d", len(args))
	}

	rows, err := a.Pool.Query(context.Background(), sql, args...)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "failed to list words")
		return
	}
	defer rows.Close()
	words := []models.Word{}
	for rows.Next() {
		var item models.Word
		if err := rows.Scan(&item.ID, &item.English, &item.Translation, &item.Example,
			&item.Meaning, &item.IsFavorite, &item.CreatedAt, &item.UpdatedAt); err != nil {
			continue
		}
		words = append(words, item)
	}
	writeJSON(w, http.StatusOK, words)
}

// CreateWord handles POST /api/words.
func (a *API) CreateWord(w http.ResponseWriter, r *http.Request) {
	var input models.WordInput
	if err := decodeJSON(r, &input); err != nil {
		writeError(w, http.StatusBadRequest, "invalid json body")
		return
	}
	input.English = capitalizeFirst(strings.TrimSpace(input.English))
	input.Translation = strings.TrimSpace(input.Translation)
	if input.English == "" || input.Translation == "" {
		writeError(w, http.StatusBadRequest, "english and translation are required")
		return
	}
	var exists bool
	if err := a.Pool.QueryRow(context.Background(),
		`SELECT EXISTS(SELECT 1 FROM words WHERE lower(english) = lower($1))`, input.English).Scan(&exists); err != nil {
		writeError(w, http.StatusInternalServerError, "failed to check duplicate")
		return
	}
	if exists {
		writeError(w, http.StatusConflict, "word already exists")
		return
	}
	var id int
	err := a.Pool.QueryRow(context.Background(),
		`INSERT INTO words (english, translation, example, meaning, is_favorite) VALUES ($1, $2, $3, $4, $5) RETURNING id`,
		input.English, input.Translation, strings.TrimSpace(input.Example), strings.TrimSpace(input.Meaning), input.IsFavorite).Scan(&id)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "failed to create word")
		return
	}
	writeJSON(w, http.StatusCreated, map[string]any{"id": id})
}

// UpdateWord handles PUT /api/words/{id}.
func (a *API) UpdateWord(w http.ResponseWriter, r *http.Request) {
	id, ok := pathID(r, "/api/words/")
	if !ok {
		writeError(w, http.StatusBadRequest, "invalid id")
		return
	}
	var input models.WordInput
	if err := decodeJSON(r, &input); err != nil {
		writeError(w, http.StatusBadRequest, "invalid json body")
		return
	}
	input.English = capitalizeFirst(strings.TrimSpace(input.English))
	input.Translation = strings.TrimSpace(input.Translation)
	if input.English == "" || input.Translation == "" {
		writeError(w, http.StatusBadRequest, "english and translation are required")
		return
	}
	var exists bool
	if err := a.Pool.QueryRow(context.Background(),
		`SELECT EXISTS(SELECT 1 FROM words WHERE lower(english) = lower($1) AND id <> $2)`,
		input.English, id).Scan(&exists); err != nil {
		writeError(w, http.StatusInternalServerError, "failed to check duplicate")
		return
	}
	if exists {
		writeError(w, http.StatusConflict, "word already exists")
		return
	}
	cmd, err := a.Pool.Exec(context.Background(),
		`UPDATE words SET english=$1, translation=$2, example=$3, meaning=$4, is_favorite=$5, updated_at=NOW() WHERE id=$6`,
		input.English, input.Translation, strings.TrimSpace(input.Example), strings.TrimSpace(input.Meaning), input.IsFavorite, id)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "failed to update word")
		return
	}
	if cmd.RowsAffected() == 0 {
		writeError(w, http.StatusNotFound, "word not found")
		return
	}
	writeJSON(w, http.StatusOK, map[string]bool{"updated": true})
}

// DeleteWord handles DELETE /api/words/{id}.
func (a *API) DeleteWord(w http.ResponseWriter, r *http.Request) {
	id, ok := pathID(r, "/api/words/")
	if !ok {
		writeError(w, http.StatusBadRequest, "invalid id")
		return
	}
	cmd, err := a.Pool.Exec(context.Background(), `DELETE FROM words WHERE id=$1`, id)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "failed to delete word")
		return
	}
	if cmd.RowsAffected() == 0 {
		writeError(w, http.StatusNotFound, "word not found")
		return
	}
	writeJSON(w, http.StatusOK, map[string]bool{"deleted": true})
}

// pathID extracts integer id from URL with given prefix.
func pathID(r *http.Request, prefix string) (int, bool) {
	raw := strings.TrimPrefix(r.URL.Path, prefix)
	parts := strings.Split(raw, "/")
	id, err := strconv.Atoi(parts[0])
	if err != nil {
		return 0, false
	}
	return id, true
}

// capitalizeFirst делает первую букву заглавной, остальное не трогает.
func capitalizeFirst(value string) string {
	if value == "" {
		return value
	}
	runes := []rune(value)
	runes[0] = unicode.ToUpper(runes[0])
	return string(runes)
}

// parseLimit читает limit: пустое или неверное значение — вернуть все записи.
func parseLimit(raw string) (int, bool) {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return 0, false
	}
	value, err := strconv.Atoi(raw)
	if err != nil || value <= 0 {
		return 0, false
	}
	return value, true
}

// parseOffset читает offset: неверное или отрицательное значение — 0.
func parseOffset(raw string) int {
	value, err := strconv.Atoi(strings.TrimSpace(raw))
	if err != nil || value < 0 {
		return 0
	}
	return value
}
