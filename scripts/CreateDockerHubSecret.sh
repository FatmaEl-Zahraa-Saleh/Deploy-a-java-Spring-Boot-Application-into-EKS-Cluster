#!/bin/bash

# Define variables using Jenkins environment variables
DOCKER_SERVER="docker.io"
DOCKER_USERNAME="$USER"  # Jenkins environment variable for Docker username
DOCKER_PASSWORD="$PASS"  # Jenkins environment variable for Docker password
KUBE_NAMESPACE="${KUBE_NAMESPACE}"  # Jenkins environment variable for Kubernetes namespace

# Create a Docker registry secret in Kubernetes
kubectl create secret docker-registry my-registry-key \
  --docker-server=$DOCKER_SERVER \
  --docker-username=$DOCKER_USERNAME \
  --docker-password=$DOCKER_PASSWORD \
  --namespace=$KUBE_NAMESPACE || true