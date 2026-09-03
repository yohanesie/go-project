# ==========================================
# STAGE 1 - BUILD FRONTEND (Vue.js / Vite)
# ==========================================
FROM node:22-alpine AS frontend-builder

WORKDIR /app/ui

# Install dependencies
COPY ui/package*.json ./
RUN npm ci

# Copy source & build
COPY ui/ .
RUN npm run build


# ==========================================
# STAGE 2 - BUILD BACKEND (Go)
# ==========================================
FROM golang:1.27-alpine AS backend-builder

WORKDIR /app

# Download Go dependencies (cache layer)
COPY go.mod go.sum ./
RUN go mod download

# Copy Go source code
COPY main.go .

# Build binary (static, no CGO)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-w -s" -o server main.go


# ==========================================
# STAGE 3 - FINAL / RUNTIME IMAGE
# ==========================================
FROM alpine:3.22

WORKDIR /app

# Install CA certificates for HTTPS calls
RUN apk --no-cache add ca-certificates tzdata

# Copy Go binary
COPY --from=backend-builder /app/server .

# Copy Vue build output
COPY --from=frontend-builder /app/ui/dist ./ui/dist

# Copy CSV data
COPY data ./data

EXPOSE 8888

CMD ["./server"]
