# Kubernetes Deployment Script for Flask Frontend and Express Backend (PowerShell)
# This script builds Docker images and deploys to minikube

Write-Host "🚀 Starting Kubernetes Deployment Script" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Check if minikube is running
$minikubeStatus = minikube status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Minikube is not running. Starting minikube..." -ForegroundColor Yellow
    minikube start
} else {
    Write-Host "✅ Minikube is running" -ForegroundColor Green
}

# Set Docker environment to use minikube's Docker daemon
Write-Host ""
Write-Host "📦 Setting up Docker environment for minikube..." -ForegroundColor Cyan
& minikube docker-env | Invoke-Expression

# Build backend Docker image
Write-Host ""
Write-Host "🔨 Building backend Docker image..." -ForegroundColor Cyan
Set-Location backend
docker build -t backend:latest .
Set-Location ..

# Build frontend Docker image
Write-Host ""
Write-Host "🔨 Building frontend Docker image..." -ForegroundColor Cyan
Set-Location frontend
docker build -t frontend:latest .
Set-Location ..

# Apply Kubernetes manifests
Write-Host ""
Write-Host "📝 Applying Kubernetes manifests..." -ForegroundColor Cyan
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml

# Wait for deployments to be ready
Write-Host ""
Write-Host "⏳ Waiting for deployments to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=available --timeout=300s deployment/backend-deployment
kubectl wait --for=condition=available --timeout=300s deployment/frontend-deployment

# Get service information
Write-Host ""
Write-Host "✅ Deployment completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Deployment Status:" -ForegroundColor Cyan
Write-Host "===================="
kubectl get deployments
Write-Host ""
kubectl get services
Write-Host ""
kubectl get pods

$minikubeIP = minikube ip
Write-Host ""
Write-Host "🌐 Access Information:" -ForegroundColor Cyan
Write-Host "===================="
Write-Host "Frontend URL: http://$minikubeIP:30080" -ForegroundColor Yellow
Write-Host ""
Write-Host "To access the application, run:" -ForegroundColor White
Write-Host "  minikube service frontend-service --url" -ForegroundColor Gray
Write-Host ""
Write-Host "Or access directly at: http://$minikubeIP:30080" -ForegroundColor Gray
