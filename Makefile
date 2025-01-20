# Variables
DOCKER_USERNAME ?= xqsit94
IMAGE_NAME := cypher
VERSION ?= v1.0.0

# Build the docker image with a specific version
build:
	docker build -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION) .

# Tag the new version as latest
tag-latest:
	docker tag $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION) $(DOCKER_USERNAME)/$(IMAGE_NAME):latest

# Run the docker image locally
run:
	docker run -p 8000:8000 $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION)

# Push the image to Docker Hub
push:
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION)

# Push the latest tag to Docker Hub
push-latest:
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):latest

# Build, tag as latest, and push in one command
deploy: build tag-latest push push-latest

# Stop all running containers
stop:
	docker stop $(docker ps -q --filter ancestor=$(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION))

# Clean up unused images
clean:
	docker rmi $(DOCKER_USERNAME)/$(IMAGE_NAME):$(VERSION)

.PHONY: build run push deploy stop clean
