#!/bin/bash

# Kubernetes Deployment Script for Flask Frontend and Express Backend
# This script builds Docker images and deploys to minikube

set -e

echo "🚀 Starting Kubernetes Deployment Script"
echo "=========================================="

# Check if minikube is running
if ! minikube status > /dev/null 2>&1; then
    echo "❌ Minikube is not running. Starting minikube..."
    minikube start
else
    echo "✅ Minikube is running"
fi

# Set Docker environment to use minikube's Docker daemon
echo "📦 Setting up Docker environment for minikube..."
eval $(minikube docker-env)

# Build backend Docker image
echo ""
echo "🔨 Building backend Docker image..."
cd backend
docker build -t backend:latest .
cd ..

# Build frontend Docker image
echo ""
echo "🔨 Building frontend Docker image..."
cd frontend
docker build -t frontend:latest .
cd ..

# Apply Kubernetes manifests
echo ""
echo "📝 Applying Kubernetes manifests..."
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml

# Wait for deployments to be ready
echo ""
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/backend-deployment
kubectl wait --for=condition=available --timeout=300s deployment/frontend-deployment

# Get service information
echo ""
echo "✅ Deployment completed!"
echo ""
echo "📊 Deployment Status:"
echo "===================="
kubectl get deployments
echo ""
kubectl get services
echo ""
kubectl get pods

echo ""
echo "🌐 Access Information:"
echo "===================="
echo "Frontend URL: http://$(minikube ip):30080"
echo ""
echo "To access the application, run:"
echo "  minikube service frontend-service --url"
echo ""
echo "Or access directly at: http://$(minikube ip):30080"
echo ""
echo "To view logs:"
echo "  kubectl logs -f deployment/frontend-deployment"
echo "  kubectl logs -f deployment/backend-deployment"
