package router

import (
	"net/http"

	"english-backend/internal/handlers"
)

// New создаёт mux со всеми маршрутами API.
func New(api *handlers.API) *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("/api/health", api.Health)
	mux.HandleFunc("/api/words", handleWords(api))
	mux.HandleFunc("/api/words/", handleWordByID(api))
	mux.HandleFunc("/api/expressions", handleExpressions(api))
	mux.HandleFunc("/api/expressions/", handleExpressionByID(api))
	return mux
}

// withCORS разрешает обращения с фронтенда.
func withCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}

// Handler возвращает mux с поддержкой CORS.
func Handler(api *handlers.API) http.Handler {
	return withCORS(New(api))
}

func handleWords(api *handlers.API) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			api.ListWords(w, r)
		case http.MethodPost:
			api.CreateWord(w, r)
		default:
			http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		}
	}
}

func handleWordByID(api *handlers.API) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodPut:
			api.UpdateWord(w, r)
		case http.MethodDelete:
			api.DeleteWord(w, r)
		default:
			http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		}
	}
}

func handleExpressions(api *handlers.API) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			api.ListExpressions(w, r)
		case http.MethodPost:
			api.CreateExpression(w, r)
		default:
			http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		}
	}
}

func handleExpressionByID(api *handlers.API) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodPut:
			api.UpdateExpression(w, r)
		case http.MethodDelete:
			api.DeleteExpression(w, r)
		default:
			http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		}
	}
}
