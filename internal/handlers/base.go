package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
)

// API bundles shared dependencies for handlers.
type API struct {
	Pool *pgxpool.Pool
}

// NewAPI creates handler bundle.
func NewAPI(pool *pgxpool.Pool) *API {
	return &API{Pool: pool}
}

// writeJSON sends JSON response with status code.
func writeJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(data)
}

// writeError sends JSON error payload.
func writeError(w http.ResponseWriter, status int, message string) {
	writeJSON(w, status, map[string]string{"error": message})
}

// decodeJSON parses request body into value.
func decodeJSON(r *http.Request, value any) error {
	defer r.Body.Close()
	return json.NewDecoder(r.Body).Decode(value)
}

// Health returns service status for smoke test.
func (a *API) Health(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok", "service": "english-backend"})
}
