-- Приводим схему к виду «только слова»: убираем лишние таблицы и колонки.
-- Сначала удаляем колонки (вместе с ними уходят индексы и внешние ключи),
-- затем — сами лишние таблицы.
ALTER TABLE words DROP COLUMN IF EXISTS transcription;
ALTER TABLE words DROP COLUMN IF EXISTS example;
ALTER TABLE words DROP COLUMN IF EXISTS example_translation;
ALTER TABLE words DROP COLUMN IF EXISTS level;
ALTER TABLE words DROP COLUMN IF EXISTS category_id;
ALTER TABLE words DROP COLUMN IF EXISTS is_learned;

DROP TABLE IF EXISTS expressions;
DROP TABLE IF EXISTS quiz_results;
DROP TABLE IF EXISTS categories CASCADE;
