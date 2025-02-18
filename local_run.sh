#!/bin/bash

# Build the Docker image
docker build -t laravel-app .

# Run the Docker container
docker run -d -p 8080:80 --name laravel-container laravel-app
