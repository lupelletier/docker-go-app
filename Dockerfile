# syntax=docker/dockerfile:1

FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o app ./app.go

FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/app ./app
EXPOSE 8080
# Environment variables for DB connection and app port
ENV APP_PORT=8080 \
    DB_USER=postgres \
    DB_PASSWORD=postgres \
    DB_HOST=db \
    DB_PORT=5432 \
    DB_NAME=postgres
CMD ["./app"]
