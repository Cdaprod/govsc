# Use the official Go image to build the application
FROM golang:1.20 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules files and install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the application binary
RUN go build -o /govsc main.go

# Use a minimal base image to run the binary
FROM debian:buster-slim

# Copy the binary from the builder image
COPY --from=builder /govsc /usr/local/bin/govsc

# Set environment variables for the application
ENV GOVCS_ETCD_ENDPOINTS="etcd:2379"
ENV GOVCS_S3_BUCKET="govcs-objects"
ENV GOVCS_REDIS_ADDR="redis:6379"
ENV GOVCS_ELASTICSEARCH_URL="http://elasticsearch:9200"
ENV GOVCS_GITHUB_TOKEN="your-github-token"

# Expose the port for the application
EXPOSE 8080

# Run the application binary
CMD ["govsc"]