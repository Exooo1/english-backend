-- Добавляем пример употребления и пояснение значения (для слов вроде house/home)
ALTER TABLE words ADD COLUMN IF NOT EXISTS example TEXT NOT NULL DEFAULT '';
ALTER TABLE words ADD COLUMN IF NOT EXISTS meaning TEXT NOT NULL DEFAULT '';
