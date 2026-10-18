# English Backend (Go + Postgres)

Бэкенд словаря английского: слова и перевод.

## Требования
- Go 1.23+
- Postgres с базой `learnenglish`

```env
DB_NAME=learnenglish
DB_USER=postgres
DB_PASSWORD=123456789aa
DB_HOST=localhost
DB_PORT=5432
```

## Запуск

```powershell
cd C:\Learn\english-backend
go run ./cmd/api
# -> http://localhost:8080
```

Миграции из каталога `migrations/` применяются автоматически при старте; учёт применённого — в таблице `schema_migrations`.

## Таблицы

- `words` — `id`, `english`, `translation`, `example`, `meaning`, `created_at`, `updated_at`
- `expressions` — то же для фразовых глаголов и идиом
- `schema_migrations` — служебная

Английское слово/выражение уникально без учёта регистра (индексы `uq_*_english_lower`).

## API

- `GET /api/health` — проверка сервиса
- `GET /api/words?search=&limit=&offset=` — список слов
- `POST /api/words` — `{english, translation, example, meaning}`
- `PUT /api/words/{id}`, `DELETE /api/words/{id}`
- `GET /api/expressions?search=&limit=&offset=` — список выражений
- `POST /api/expressions`, `PUT /api/expressions/{id}`, `DELETE /api/expressions/{id}`
- Повтор → `409 Conflict {"error":"... already exists"}`

## Структура
```
cmd/api/main.go
internal/config/   — загрузка env
internal/db/       — pgxpool + миграции
internal/models/   — типы
internal/handlers/ — words
internal/router/   — маршруты + CORS
migrations/
```
