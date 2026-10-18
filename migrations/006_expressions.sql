-- Выражения: фразовые глаголы, идиомы и устойчивые сочетания
CREATE TABLE IF NOT EXISTS expressions (
  id SERIAL PRIMARY KEY,
  english VARCHAR(255) NOT NULL,
  translation VARCHAR(255) NOT NULL,
  example TEXT NOT NULL DEFAULT '',
  meaning TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
