# Variables
DOCKER_USERNAME ?= xqsit94
IMAGE_NAME := cypher
VERSION ?= latest

# Build the docker image
build:
	docker build -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION) .

# Run the docker image locally
run:
	docker run -p 8000:8000 $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION)

# Push the image to Docker Hub
push:
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION)

# Build and push in one command
deploy: build push

# Stop all running containers
stop:
	docker stop $$(docker ps -q --filter ancestor=$(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION))

# Clean up unused images
clean:
	docker rmi $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION)

.PHONY: build run push deploy stop clean
