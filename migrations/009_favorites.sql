-- Избранное: отметка записей для быстрого повторения.
ALTER TABLE words ADD COLUMN IF NOT EXISTS is_favorite BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE expressions ADD COLUMN IF NOT EXISTS is_favorite BOOLEAN NOT NULL DEFAULT FALSE;
