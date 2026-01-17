# Mini-Test - Go HTTP Health Check Service

## Project Overview

A minimal Go HTTP service that exposes a `/health` endpoint. Designed as a test case for the enhanced project management system and Docker label-based reverse proxy integration.

**Host:** `health.gottz.de`
**Port:** 8080 (internal)

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    reverseproxy network                   │
│                                                           │
│  ┌─────────────┐         ┌─────────────────────────────┐ │
│  │  reversed   │────────▶│       mini-test             │ │
│  │   proxy     │         │                             │ │
│  │             │         │  ┌───────────────────────┐  │ │
│  │ health.     │  :8080  │  │    Go HTTP Server     │  │ │
│  │ gottz.de    │─────────│  │                       │  │ │
│  └─────────────┘         │  │  GET /health          │  │ │
│                          │  │  {"status":"ok",...}  │  │ │
│                          │  └───────────────────────┘  │ │
│                          └─────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

**Components:**
- `main.go` - Single-file HTTP server with `/health` endpoint
- `Dockerfile` - Multi-stage build (builder + scratch/alpine)
- `docker-compose.yml` - Container orchestration with reversed labels

## Phase 1 Quirks

<!-- Quirks discovered during implementation phase -->

## Phase 2 Quirks

1. **Port mapping for local testing**: The `reversed.port` label tells the reverse proxy which port to use, but for direct localhost testing, you also need explicit `ports: - "8080:8080"` in docker-compose.yml to expose the port to the host.

## Quick Reference

### Build & Run
```bash
cd /compose/mini-test

# Build and start
docker compose up -d --build

# View logs
docker compose logs -f

# Stop
docker compose down
```

### Local Testing
```bash
# Direct container test (after starting)
curl http://localhost:8080/health

# Via reverse proxy (requires reversed running)
curl -H "Host: health.gottz.de" http://localhost:8080/
```

### Development
```bash
# Run locally without Docker
go run main.go

# Build binary
go build -o mini-test main.go
```

### Verify Integration
```bash
# Check container is on reverseproxy network
docker inspect mini-test-app-1 | jq '.[0].NetworkSettings.Networks.reverseproxy'

# Check labels
docker inspect mini-test-app-1 | jq '.[0].Config.Labels'

# Check reversed discovered the route
curl -s http://localhost:8080/__reversed/routes | jq '.["health.gottz.de"]'
```
