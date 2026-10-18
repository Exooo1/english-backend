package handlers

import (
	"context"
	"fmt"
	"net/http"
	"strings"

	"english-backend/internal/models"
)

// ListExpressions handles GET /api/expressions?search=&limit=&offset=
func (a *API) ListExpressions(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	search := strings.TrimSpace(q.Get("search"))
	limit, hasLimit := parseLimit(q.Get("limit"))
	offset := parseOffset(q.Get("offset"))

	sql := `SELECT id, english, translation, example, meaning, is_favorite, created_at, updated_at FROM expressions WHERE 1=1`
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
		writeError(w, http.StatusInternalServerError, "failed to list expressions")
		return
	}
	defer rows.Close()
	items := []models.Expression{}
	for rows.Next() {
		var item models.Expression
		if err := rows.Scan(&item.ID, &item.English, &item.Translation, &item.Example,
			&item.Meaning, &item.IsFavorite, &item.CreatedAt, &item.UpdatedAt); err != nil {
			continue
		}
		items = append(items, item)
	}
	writeJSON(w, http.StatusOK, items)
}

// CreateExpression handles POST /api/expressions.
func (a *API) CreateExpression(w http.ResponseWriter, r *http.Request) {
	var input models.ExpressionInput
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
		`SELECT EXISTS(SELECT 1 FROM expressions WHERE lower(english) = lower($1))`, input.English).Scan(&exists); err != nil {
		writeError(w, http.StatusInternalServerError, "failed to check duplicate")
		return
	}
	if exists {
		writeError(w, http.StatusConflict, "expression already exists")
		return
	}
	var id int
	err := a.Pool.QueryRow(context.Background(),
		`INSERT INTO expressions (english, translation, example, meaning, is_favorite) VALUES ($1, $2, $3, $4, $5) RETURNING id`,
		input.English, input.Translation, strings.TrimSpace(input.Example), strings.TrimSpace(input.Meaning), input.IsFavorite).Scan(&id)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "failed to create expression")
		return
	}
	writeJSON(w, http.StatusCreated, map[string]any{"id": id})
}

// UpdateExpression handles PUT /api/expressions/{id}.
func (a *API) UpdateExpression(w http.ResponseWriter, r *http.Request) {
	id, ok := pathID(r, "/api/expressions/")
	if !ok {
		writeError(w, http.StatusBadRequest, "invalid id")
		return
	}
	var input models.ExpressionInput
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
		`SELECT EXISTS(SELECT 1 FROM expressions WHERE lower(english) = lower($1) AND id <> $2)`,
		input.English, id).Scan(&exists); err != nil {
		writeError(w, http.StatusInternalServerError, "failed to check duplicate")
		return
	}
	if exists {
		writeError(w, http.StatusConflict, "expression already exists")
		return
	}
	cmd, err := a.Pool.Exec(context.Background(),
		`UPDATE expressions SET english=$1, translation=$2, example=$3, meaning=$4, is_favorite=$5, updated_at=NOW() WHERE id=$6`,
		input.English, input.Translation, strings.TrimSpace(input.Example), strings.TrimSpace(input.Meaning), input.IsFavorite, id)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "failed to update expression")
		return
	}
	if cmd.RowsAffected() == 0 {
		writeError(w, http.StatusNotFound, "expression not found")
		return
	}
	writeJSON(w, http.StatusOK, map[string]bool{"updated": true})
}

// DeleteExpression handles DELETE /api/expressions/{id}.
func (a *API) DeleteExpression(w http.ResponseWriter, r *http.Request) {
	id, ok := pathID(r, "/api/expressions/")
	if !ok {
		writeError(w, http.StatusBadRequest, "invalid id")
		return
	}
	cmd, err := a.Pool.Exec(context.Background(), `DELETE FROM expressions WHERE id=$1`, id)
	if err != nil {
		writeError(w, http.StatusInternalServerError, "failed to delete expression")
		return
	}
	if cmd.RowsAffected() == 0 {
		writeError(w, http.StatusNotFound, "expression not found")
		return
	}
	writeJSON(w, http.StatusOK, map[string]bool{"deleted": true})
}
