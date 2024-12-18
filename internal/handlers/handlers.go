package handlers

import (
	"encoding/json"
	"html/template"
	"net/http"
	"os"
	"strings"

	"github.com/xqsit94/cypher/internal/crypto"
)

type Response struct {
	Success bool   `json:"success"`
	Result  string `json:"result"`
	Error   string `json:"error,omitempty"`
}

type PageData struct {
	SecretKey string
	SaltKey   string
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	data := PageData{
		SecretKey: os.Getenv("SECRET_KEY"),
		SaltKey:   os.Getenv("SALT_KEY"),
	}

	tmpl := template.Must(template.ParseFiles("internal/templates/index.gohtml"))
	if err := tmpl.Execute(w, data); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func EncryptHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	if err := r.ParseForm(); err != nil {
		json.NewEncoder(w).Encode(Response{
			Success: false,
			Error:   "Invalid form data",
		})
		return
	}

	plaintext := strings.TrimSpace(r.FormValue("text"))
	secret := strings.TrimSpace(r.FormValue("secret"))
	salt := strings.TrimSpace(r.FormValue("salt"))

	if plaintext == "" || secret == "" || salt == "" {
		json.NewEncoder(w).Encode(Response{
			Success: false,
			Error:   "Missing required fields",
		})
		return
	}

	key := crypto.GenerateKey(salt, secret)

	result, err := crypto.Encrypt(plaintext, key)
	if err != nil {
		json.NewEncoder(w).Encode(Response{
			Success: false,
			Error:   err.Error(),
		})
		return
	}

	json.NewEncoder(w).Encode(Response{
		Success: true,
		Result:  result,
	})
}

func DecryptHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	if err := r.ParseForm(); err != nil {
		json.NewEncoder(w).Encode(Response{
			Success: false,
			Error:   "Invalid form data",
		})
		return
	}

	ciphertext := strings.TrimSpace(r.FormValue("text"))
	secret := strings.TrimSpace(r.FormValue("secret"))
	salt := strings.TrimSpace(r.FormValue("salt"))

	if ciphertext == "" || secret == "" || salt == "" {
		json.NewEncoder(w).Encode(Response{
			Success: false,
			Error:   "Missing required fields",
		})
		return
	}

	key := crypto.GenerateKey(salt, secret)

	result, err := crypto.Decrypt(ciphertext, key)
	if err != nil {
		json.NewEncoder(w).Encode(Response{
			Success: false,
			Error:   err.Error(),
		})
		return
	}

	json.NewEncoder(w).Encode(Response{
		Success: true,
		Result:  result,
	})
}
