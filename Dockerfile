# ── Stage 1: Build ────────────────────────────────────────────────
FROM golang:1.27-alpine AS builder

WORKDIR /app

# Install git (dibutuhkan oleh beberapa modul Go)
RUN apk add --no-cache git

# Download dependencies dulu (layer cache lebih efisien)
COPY go.mod go.sum ./
RUN go mod download

# Copy semua source code
COPY . .

# Build binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .

# ── Stage 2: Final Image ──────────────────────────────────────────
FROM alpine:3.20

WORKDIR /app

# CA certificates untuk HTTPS calls
RUN apk --no-cache add ca-certificates tzdata

# Copy binary dari builder
COPY --from=builder /app/main .

# Copy folder data (CSV files)
COPY data/ ./data/

EXPOSE 8888

CMD ["./main"]
