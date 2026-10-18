-- Английские слова начинаются с заглавной буквы
UPDATE words
SET english = upper(substr(english, 1, 1)) || substr(english, 2)
WHERE english <> ''
  AND english <> upper(substr(english, 1, 1)) || substr(english, 2);
