package models

import "time"

// Word — слово с переводом, примером и пояснением значения.
type Word struct {
	ID          int       `json:"id"`
	English     string    `json:"english"`
	Translation string    `json:"translation"`
	Example     string    `json:"example"`
	Meaning     string    `json:"meaning"`
	IsFavorite  bool      `json:"isFavorite"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}

// WordInput — payload для создания и обновления слова.
type WordInput struct {
	English     string `json:"english"`
	Translation string `json:"translation"`
	Example     string `json:"example"`
	Meaning     string `json:"meaning"`
	IsFavorite  bool   `json:"isFavorite"`
}

// Expression — выражение: фразовый глагол, идиома, устойчивое сочетание.
type Expression struct {
	ID          int       `json:"id"`
	English     string    `json:"english"`
	Translation string    `json:"translation"`
	Example     string    `json:"example"`
	Meaning     string    `json:"meaning"`
	IsFavorite  bool      `json:"isFavorite"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}

// ExpressionInput — payload для создания и обновления выражения.
type ExpressionInput struct {
	English     string `json:"english"`
	Translation string `json:"translation"`
	Example     string `json:"example"`
	Meaning     string `json:"meaning"`
	IsFavorite  bool   `json:"isFavorite"`
}
