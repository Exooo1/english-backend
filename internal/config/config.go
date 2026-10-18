package config

// Config holds application configuration loaded from environment.
type Config struct {
	Port        string
	DatabaseURL string
}

// LoadConfig reads configuration from environment variables with defaults.
func LoadConfig(getenv func(string) string) Config {
	port := getenv("PORT")
	if port == "" {
		port = "8080"
	}
	dbURL := getenv("DATABASE_URL")
	if dbURL == "" {
		// Build from separate parts: DB_USER, DB_PASSWORD, DB_HOST, DB_PORT, DB_NAME
		user := getenv("DB_USER")
		if user == "" {
			user = "postgres"
		}
		pass := getenv("DB_PASSWORD")
		host := getenv("DB_HOST")
		if host == "" {
			host = "localhost"
		}
		dbPort := getenv("DB_PORT")
		if dbPort == "" {
			dbPort = "5432"
		}
		name := getenv("DB_NAME")
		if name == "" {
			name = "learnenglish"
		}
		if pass != "" {
			dbURL = "postgres://" + user + ":" + pass + "@" + host + ":" + dbPort + "/" + name + "?sslmode=disable"
		} else {
			dbURL = "postgres://" + user + "@" + host + ":" + dbPort + "/" + name + "?sslmode=disable"
		}
	}
	return Config{Port: port, DatabaseURL: dbURL}
}
