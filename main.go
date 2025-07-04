package main

import (
	"encoding/json"
	"net/http"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		res := &struct {
			Message string `json:"message"`
		}{
			Message: "Status OK updated with github actions",
		}
		json.NewEncoder(w).Encode(res)
	})

	http.ListenAndServe(":8080", nil)
}
