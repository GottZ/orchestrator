# Stage 1: Build
FROM golang:alpine AS builder

WORKDIR /app
COPY main.go .
RUN go build -o mini-test main.go

# Stage 2: Runtime
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/mini-test .

EXPOSE 8080

CMD ["./mini-test"]
