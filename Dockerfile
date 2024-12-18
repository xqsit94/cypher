# Start with a golang base image
FROM golang:1.23-alpine

# Set working directory
WORKDIR /app

# Install git (required for go get)
RUN apk add --no-cache git

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Create a new stage with a minimal image
FROM alpine:3.19

# Set working directory
WORKDIR /app

# Copy the binary from builder
COPY --from=0 /app/main .
# Copy static files and templates
COPY --from=0 /app/static ./static
COPY --from=0 /app/internal/templates ./internal/templates

# Copy the .env file
COPY .env .

# Expose port 8860
EXPOSE 8860

# Set environment variable for the port
ENV PORT=8860

# Run the binary
CMD ["./main"]
