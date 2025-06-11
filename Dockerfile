# Dockerfile for a simple Go application
# using multi-stage builds to keep the final image small

# Use the official Golang image as the build stage
#Could have used a specific version of Alpine, but using the latest stable version for simplicity
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o app ./app.go

# Use the official Alpine image as the final stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/app ./app
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD wget --spider -q http://localhost:8080/_internal/health || exit 1
CMD ["./app"]
