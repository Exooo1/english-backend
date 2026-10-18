-- LearnEnglish: слова и перевод
CREATE TABLE IF NOT EXISTS words (
  id SERIAL PRIMARY KEY,
  english VARCHAR(255) NOT NULL,
  translation VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
