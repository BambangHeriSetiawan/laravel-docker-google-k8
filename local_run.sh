#!/bin/bash

# Stop and remove the existing container if it exists
if [ "$(docker ps -aq -f name=laravel-container)" ]; then
    echo "Stopping and removing existing container..."
    docker stop laravel-container
    docker rm laravel-container
fi

# Build the Docker image
echo "Building the Docker image..."
docker build -t laravel-app .

# Run the Docker container
echo "Running the Docker container..."
docker run -d -p 8080:80 --name laravel-container laravel-app

# Test the Nginx configuration
echo "Testing Nginx configuration..."
docker exec -it laravel-container nginx -t
