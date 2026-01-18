# Kubernetes Deployment: Flask Frontend + Express Backend

This project demonstrates deploying a Flask frontend and Express backend application on a local Kubernetes cluster using Minikube.

## 📋 Project Structure

```
.
├── frontend/                 # Flask frontend application
│   ├── app.py               # Flask application
│   ├── requirements.txt     # Python dependencies
│   ├── Dockerfile          # Frontend Docker image
│   └── templates/          # HTML templates
│       └── index.html
├── backend/                 # Express backend application
│   ├── server.js           # Express server
│   ├── package.json        # Node.js dependencies
│   └── Dockerfile          # Backend Docker image
├── k8s/                     # Kubernetes manifests
│   ├── backend-deployment.yaml
│   └── frontend-deployment.yaml
├── deploy.sh               # Bash deployment script
├── deploy.ps1              # PowerShell deployment script
└── README.md               # This file
```

## 🚀 Prerequisites

Before deploying, ensure you have the following installed:

1. **Minikube** - Local Kubernetes cluster
   ```bash
   # Download from https://minikube.sigs.k8s.io/docs/start/
   ```

2. **kubectl** - Kubernetes command-line tool
   ```bash
   # Download from https://kubernetes.io/docs/tasks/tools/
   ```

3. **Docker** - Container runtime
   ```bash
   # Download from https://www.docker.com/get-started
   ```

## 📦 Installation Steps

### 1. Start Minikube

```bash
# Start minikube (if not already running)
minikube start

# Verify minikube is running
minikube status
```

### 2. Build Docker Images

You need to build Docker images using minikube's Docker daemon:

**On Linux/Mac:**
```bash
# Set Docker environment
eval $(minikube docker-env)

# Build backend image
cd backend
docker build -t backend:latest .
cd ..

# Build frontend image
cd frontend
docker build -t frontend:latest .
cd ..
```

**On Windows (PowerShell):**
```powershell
# Set Docker environment
& minikube docker-env | Invoke-Expression

# Build backend image
cd backend
docker build -t backend:latest .
cd ..

# Build frontend image
cd frontend
docker build -t frontend:latest .
cd ..
```

### 3. Deploy to Kubernetes

**Option A: Using the deployment script (Recommended)**

**Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh
```

**Windows:**
```powershell
.\deploy.ps1
```

**Option B: Manual deployment**
```bash
# Apply backend deployment
kubectl apply -f k8s/backend-deployment.yaml

# Apply frontend deployment
kubectl apply -f k8s/frontend-deployment.yaml

# Check deployment status
kubectl get deployments
kubectl get services
kubectl get pods
```

## 🌐 Accessing the Application

### Get Minikube IP
```bash
minikube ip
```

### Access Frontend
The frontend is exposed via NodePort on port 30080:

```bash
# Option 1: Get service URL
minikube service frontend-service --url

# Option 2: Direct access (replace <MINIKUBE_IP> with actual IP)
# http://<MINIKUBE_IP>:30080
```

Example: `http://192.168.49.2:30080`

### Access Backend (Internal)
The backend is accessible internally via the service name:
- Service name: `backend-service`
- Port: `3000`

The frontend automatically connects to the backend using the service name.

## 🔍 Useful Commands

### View Deployments
```bash
kubectl get deployments
kubectl describe deployment frontend-deployment
kubectl describe deployment backend-deployment
```

### View Services
```bash
kubectl get services
kubectl describe service frontend-service
kubectl describe service backend-service
```

### View Pods
```bash
kubectl get pods
kubectl get pods -l app=frontend
kubectl get pods -l app=backend
```

### View Logs
```bash
# Frontend logs
kubectl logs -f deployment/frontend-deployment

# Backend logs
kubectl logs -f deployment/backend-deployment

# Specific pod logs
kubectl logs <pod-name>
```

### Scale Deployments
```bash
# Scale frontend to 3 replicas
kubectl scale deployment frontend-deployment --replicas=3

# Scale backend to 3 replicas
kubectl scale deployment backend-deployment --replicas=3
```

### Delete Deployments
```bash
kubectl delete -f k8s/backend-deployment.yaml
kubectl delete -f k8s/frontend-deployment.yaml
```

### Port Forward (Alternative Access)
```bash
# Forward frontend port
kubectl port-forward service/frontend-service 5000:5000
# Access at http://localhost:5000

# Forward backend port
kubectl port-forward service/backend-service 3000:3000
# Access at http://localhost:3000
```

## 📸 Screenshots Checklist

For your submission, capture screenshots of:

1. ✅ Minikube status
   ```bash
   minikube status
   ```

2. ✅ Kubernetes deployments
   ```bash
   kubectl get deployments
   ```

3. ✅ Kubernetes services
   ```bash
   kubectl get services
   ```

4. ✅ Kubernetes pods
   ```bash
   kubectl get pods
   ```

5. ✅ Frontend application in browser
   - Access the frontend URL and show it working

6. ✅ Pod logs showing services running
   ```bash
   kubectl logs <pod-name>
   ```

7. ✅ Describe commands showing full configuration
   ```bash
   kubectl describe deployment frontend-deployment
   kubectl describe deployment backend-deployment
   ```

## 🐛 Troubleshooting

### Pods are not starting
```bash
# Check pod status
kubectl get pods
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

### Images not found
```bash
# Ensure you're using minikube's Docker daemon
eval $(minikube docker-env)  # Linux/Mac
# OR
& minikube docker-env | Invoke-Expression  # Windows

# Rebuild images
docker build -t backend:latest ./backend
docker build -t frontend:latest ./frontend
```

### Cannot access frontend
```bash
# Check if service is running
kubectl get services

# Verify NodePort
kubectl describe service frontend-service

# Check minikube IP
minikube ip
```

### Frontend cannot connect to backend
```bash
# Verify backend service exists
kubectl get service backend-service

# Check if backend pods are running
kubectl get pods -l app=backend

# Check backend logs
kubectl logs -l app=backend
```

## 📝 Features

- **Flask Frontend**: Modern web interface with responsive design
- **Express Backend**: RESTful API with CORS enabled
- **Kubernetes Deployments**: Scalable and resilient deployments
- **Health Checks**: Liveness and readiness probes
- **Service Discovery**: Automatic service-to-service communication
- **Resource Limits**: CPU and memory constraints defined

## 🎯 API Endpoints

### Backend
- `GET /api/data` - Get data from backend
- `POST /api/message` - Send a message to backend
- `GET /health` - Health check endpoint

### Frontend
- `GET /` - Main web page
- `GET /api/data` - Proxy to backend `/api/data`
- `POST /api/message` - Proxy to backend `/api/message`
- `GET /health` - Health check endpoint

## 📚 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Express Documentation](https://expressjs.com/)

## 📄 License

This project is for educational purposes.

---

**Happy Deploying! 🚀**
