# End-to-End CI/CD Pipeline with Jenkins, Docker, and AWS EKS

## Project Overview

This project demonstrates the implementation of a complete CI/CD pipeline using GitHub, Jenkins, Docker, Docker Hub, Amazon EKS, and Kubernetes.

The pipeline automates the entire software delivery process from source code commit to deployment on a Kubernetes cluster running on AWS EKS.

Whenever a developer pushes code to GitHub, Jenkins automatically triggers a build, creates a Docker image, pushes it to Docker Hub, and deploys the latest version to Amazon EKS.

---

## Architecture

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼ (Webhook)
Jenkins Server
    │
    ├── Build Docker Image
    │
    ├── Push Image to Docker Hub
    │
    ▼
Amazon EKS Cluster
    │
    ├── Kubernetes Deployment
    │
    ├── Pods
    │
    ▼
LoadBalancer Service
    │
    ▼
End Users
```

---

## Technologies Used

### Cloud
- AWS EC2
- AWS EKS
- IAM
- Security Groups

### DevOps Tools
- Jenkins
- Docker
- Docker Hub
- GitHub

### Container Orchestration
- Kubernetes
- kubectl
- eksctl

### Operating System
- Ubuntu Linux

---

## Project Workflow

# Step 1: Developer Server Setup

Launch an Ubuntu EC2 instance and connect to it.

## Install Required Packages

```bash
sudo su -

apt-get update -y

apt install unzip -y
```

## Download Application Source Code

```bash
wget <application-zip-url>
```

## Extract Files

```bash
unzip <filename>.zip

ls
```

## Remove ZIP File

```bash
rm -rf <filename>.zip
```

## Navigate to Project Directory

```bash
cd <project-folder>

ls
```

---

# Create Dockerfile

```bash
vim Dockerfile
```

Add the following content:

```dockerfile
FROM ubuntu

RUN apt-get update -y

RUN apt-get install -y apache2

COPY . /var/www/html

CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]
```

Save and Exit:

```bash
:wq!
```

---

# Push Source Code to GitHub

Initialize Git Repository:

```bash
git init
```

Add Files:

```bash
git add *
```

Commit Changes:

```bash
git commit -m "all data"
```

Create a repository in GitHub and copy the repository URL.

Connect Local Repository to GitHub:

```bash
git remote add origin <github-repository-url>
```

Push Code:

```bash
git push origin master
```

Provide GitHub Username and Personal Access Token when prompted.





---------------------------------------------------------------------------------------------------------------













### Step 1: Developer Pushes Code

Developer updates application source code and pushes changes to GitHub.

```bash
git add .
git commit -m "updated application"
git push origin master
```

---

### Step 2: GitHub Webhook Triggers Jenkins

GitHub webhook automatically notifies Jenkins whenever code changes are pushed.

```text
GitHub → Jenkins Webhook
```

---

### Step 3: Jenkins Pipeline Starts

Jenkins performs:

- Source Code Checkout
- Docker Image Build
- Docker Image Tagging
- Docker Hub Push
- EKS Deployment

---

### Step 4: Build Docker Image

```bash
docker build -t app-image .
```

---

### Step 5: Push Image to Docker Hub

```bash
docker login
docker push username/app-image:latest
```

---

### Step 6: Deploy to Amazon EKS

Jenkins connects to the EKS cluster and updates the deployment.

```bash
kubectl apply -f deployment.yml

kubectl set image deployment/app-deployment \
app-container=username/app-image:latest
```

---

### Step 7: Verify Deployment

```bash
kubectl get pods

kubectl get svc

kubectl get deployments
```

---

## Jenkins Setup

### Install Jenkins

```bash
sudo apt update -y

sudo apt install openjdk-21-jre -y

sudo apt install jenkins -y

sudo systemctl start jenkins

sudo systemctl enable jenkins
```

Open:

```text
http://<JENKINS_PUBLIC_IP>:8080
```

---

## Docker Installation

```bash
sudo apt install docker.io -y

sudo systemctl start docker

sudo systemctl enable docker

sudo usermod -aG docker jenkins
```

---

## AWS CLI Configuration

```bash
aws configure
```

Provide:

```text
Access Key
Secret Key
Region
Output Format
```

---

## Install eksctl

```bash
curl --silent --location \
https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz \
| tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin
```

Verify:

```bash
eksctl version
```

---

## Install kubectl

```bash
curl -LO \
https://dl.k8s.io/release/stable/bin/linux/amd64/kubectl

chmod +x kubectl

sudo mv kubectl /usr/local/bin/
```

Verify:

```bash
kubectl version --client
```

---

## Create EKS Cluster

Example:

```bash
eksctl create cluster \
--name demo-cluster \
--region us-east-2 \
--nodes 2
```

---

## Configure kubectl

```bash
aws eks update-kubeconfig \
--region us-east-2 \
--name demo-cluster
```

Verify:

```bash
kubectl get nodes
```

---

## Kubernetes Deployment

### deployment.yml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: app-deployment

spec:
  replicas: 2

  selector:
    matchLabels:
      app: myapp

  template:
    metadata:
      labels:
        app: myapp

    spec:
      containers:
      - name: app-container
        image: username/app-image:latest

        ports:
        - containerPort: 80
```

Apply:

```bash
kubectl apply -f deployment.yml
```

---

## Kubernetes Service

### service.yml

```yaml
apiVersion: v1
kind: Service

metadata:
  name: app-service

spec:
  type: LoadBalancer

  selector:
    app: myapp

  ports:
  - port: 80
    targetPort: 80
```

Apply:

```bash
kubectl apply -f service.yml
```

Check Service:

```bash
kubectl get svc
```

---

## Jenkins Pipeline Stages

### 1. Clone Code

```text
Checkout source code from GitHub
```

### 2. Build Docker Image

```text
Create Docker image
```

### 3. Push Docker Image

```text
Push image to Docker Hub
```

### 4. Configure EKS

```text
Authenticate Jenkins with AWS
```

### 5. Deploy to Kubernetes

```text
Update deployment image
```

### 6. Verify Deployment

```text
Check deployment rollout status
```

---

## Load Balancer Access

Retrieve External URL:

```bash
kubectl get svc
```

Example:

```text
EXTERNAL-IP: a1b2c3d4.us-east-2.elb.amazonaws.com
```

Open in browser:

```text
http://EXTERNAL-IP
```

---

## Project Features

- Automated CI/CD Pipeline
- GitHub Webhook Integration
- Docker Containerization
- Docker Hub Image Registry
- Jenkins Automation
- Kubernetes Deployment
- Amazon EKS Integration
- Load Balancer Exposure
- Zero Manual Deployment
- Scalable Architecture

---

## Future Enhancements

- Terraform Infrastructure Automation
- Helm Charts
- Monitoring with Prometheus & Grafana
- ArgoCD GitOps Deployment
- Blue-Green Deployment
- Canary Releases

---

## Author

Shivangi Mishra

AWS | DevOps Engineer
