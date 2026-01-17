# Mini-Test Project Reference

## Go HTTP Server Pattern

### Basic Health Endpoint

```go
package main

import (
    "encoding/json"
    "net/http"
    "time"
)

type HealthResponse struct {
    Status    string `json:"status"`
    Timestamp string `json:"timestamp"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    response := HealthResponse{
        Status:    "ok",
        Timestamp: time.Now().UTC().Format(time.RFC3339),
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}

func main() {
    http.HandleFunc("/health", healthHandler)
    http.ListenAndServe(":8080", nil)
}
```

### With Graceful Shutdown

```go
package main

import (
    "context"
    "encoding/json"
    "log"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "time"
)

func main() {
    mux := http.NewServeMux()
    mux.HandleFunc("/health", healthHandler)

    server := &http.Server{
        Addr:         ":8080",
        Handler:      mux,
        ReadTimeout:  5 * time.Second,
        WriteTimeout: 10 * time.Second,
    }

    // Start server in goroutine
    go func() {
        log.Println("Starting server on :8080")
        if err := server.ListenAndServe(); err != http.ErrServerClosed {
            log.Fatalf("Server error: %v", err)
        }
    }()

    // Wait for interrupt
    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit

    // Graceful shutdown
    ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
    defer cancel()
    server.Shutdown(ctx)
    log.Println("Server stopped")
}
```

## Dockerfile Multi-Stage Build

### Minimal (scratch)

```dockerfile
# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY main.go .

# Build static binary (no CGO for scratch compatibility)
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o server main.go

# Runtime stage
FROM scratch

COPY --from=builder /app/server /server

EXPOSE 8080

ENTRYPOINT ["/server"]
```

### With Alpine (if you need shell/debugging)

```dockerfile
# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY main.go .

RUN go build -ldflags="-s -w" -o server main.go

# Runtime stage
FROM alpine:3.19

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/server /server

EXPOSE 8080

ENTRYPOINT ["/server"]
```

## Docker Compose with Reversed Labels

```yaml
services:
  app:
    build: .
    restart: unless-stopped
    networks:
      - reverseproxy
    labels:
      - "reversed.host=health.gottz.de"
      - "reversed.port=8080"

networks:
  reverseproxy:
    external: true
```

### Full Labels Reference

```yaml
labels:
  - "reversed.host=health.gottz.de"      # Required: hostname
  - "reversed.port=8080"                  # Container port (default: 80)
  - "reversed.ssl=gottz.de"               # SSL cert (default: derived from host)
  - "reversed.websocket=false"            # WebSocket support (default: true)
  - "reversed.max_body=10M"               # Max body size (default: 0/unlimited)
  - "reversed.auth=false"                 # Require auth (default: false)
```

## Testing Commands

```bash
# Build and run locally
go run main.go &
curl http://localhost:8080/health

# Docker build test
docker build -t mini-test .
docker run --rm -p 8080:8080 mini-test &
curl http://localhost:8080/health

# Docker compose
docker compose up -d
docker compose logs -f
curl http://localhost:8080/health

# JSON validation
curl -s http://localhost:8080/health | jq .

# Expected response
# {"status":"ok","timestamp":"2024-01-15T10:30:00Z"}
```
