# Quick Start Guide

## One-Command Deployment (PowerShell)

```powershell
.\deploy.ps1
```

## Step-by-Step Manual Deployment

### 1. Start Minikube
```powershell
minikube start
```

### 2. Set Docker Environment
```powershell
& minikube docker-env | Invoke-Expression
```

### 3. Build Images
```powershell
cd backend
docker build -t backend:latest .
cd ..

cd frontend
docker build -t frontend:latest .
cd ..
```

### 4. Deploy to Kubernetes
```powershell
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml
```

### 5. Check Status
```powershell
kubectl get deployments
kubectl get services
kubectl get pods
```

### 6. Access Application
```powershell
$ip = minikube ip
Write-Host "Frontend: http://$ip:30080"
```

Or use:
```powershell
minikube service frontend-service --url
```

## Verification Commands

```powershell
# Get all resources
kubectl get all

# View pod logs
kubectl logs -f deployment/frontend-deployment
kubectl logs -f deployment/backend-deployment

# Describe services
kubectl describe deployment frontend-deployment
kubectl describe deployment backend-deployment
```

## Cleanup

```powershell
kubectl delete -f k8s/backend-deployment.yaml
kubectl delete -f k8s/frontend-deployment.yaml
```
