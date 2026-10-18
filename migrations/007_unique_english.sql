-- Запрещаем повторы: одно английское слово/выражение встречается один раз (без учёта регистра)
CREATE UNIQUE INDEX IF NOT EXISTS uq_words_english_lower ON words (lower(english));
CREATE UNIQUE INDEX IF NOT EXISTS uq_expressions_english_lower ON expressions (lower(english));
