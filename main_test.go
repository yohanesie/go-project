package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
)

func TestHealthEndpoint(t *testing.T) {
	e := echo.New()
	e.GET("/api/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"status": "OK",
		})
	})

	req := httptest.NewRequest(http.MethodGet, "/api/health", nil)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rec.Code)
	}

	var body map[string]string
	if err := json.Unmarshal(rec.Body.Bytes(), &body); err != nil {
		t.Fatalf("failed to parse response body: %v", err)
	}

	if body["status"] != "OK" {
		t.Errorf("expected status=OK, got %s", body["status"])
	}
}

func TestReadCSVNotFound(t *testing.T) {
	_, err := readCSV("nonexistent.csv")
	if err == nil {
		t.Error("expected error when reading non-existent file, got nil")
	}
}
