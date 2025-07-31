# --- Updated Dockerfile ---
FROM golang:1.24.3-alpine AS builder

RUN apk add --no-cache ca-certificates git
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o app .  # Static build

FROM alpine:latest
RUN apk add --no-cache ca-certificates

RUN addgroup -g 1000 airbyte && \
    adduser -u 1000 -G airbyte -D airbyte

WORKDIR /airbyte
COPY --from=builder /build/app ./app

RUN chmod +x ./app && chown airbyte:airbyte ./app
USER airbyte

# FIX: Use Docker's native ENTRYPOINT instead of environment variable
ENTRYPOINT ["./app"]

# Optional label for Airbyte
LABEL io.airbyte.entrypoint="./app"
