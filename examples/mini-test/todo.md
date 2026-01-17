# Mini-Test Todo

## Phase 1: Implementation

- [x] **1.1 Create main.go**
  - Go HTTP server with /health endpoint returning JSON
  - Include timestamp in ISO 8601 format
  - Listen on port 8080
  - verify: `go build -o /dev/null main.go`

- [x] **1.2 Create Dockerfile**
  - Multi-stage build: golang:alpine builder, scratch/alpine runtime
  - Copy only the binary to final image
  - Expose port 8080
  - depends_on: 1.1
  - verify: `docker build -t mini-test-verify . && docker rmi mini-test-verify`

- [x] **1.3 Create docker-compose.yml**
  - Join external reverseproxy network
  - Add reversed.* labels for health.gottz.de
  - depends_on: 1.2
  - verify: `docker compose config`

## Phase 2: Deployment & Verification

- [x] **2.1 Deploy and test locally**
  - Start container with docker compose up -d
  - Test /health endpoint directly
  - depends_on: 1.3
  - verify: `curl -sf http://localhost:8080/health | jq -e '.status == "ok"'`

- [x] **2.2 Verify reverse proxy integration**
  - Confirm container joined reverseproxy network
  - Confirm reversed discovered the route (if reversed is running)
  - depends_on: 2.1
  - parallel_safe: true
  - verify: `docker inspect mini-test-app-1 | jq -e '.[0].NetworkSettings.Networks.reverseproxy'`
