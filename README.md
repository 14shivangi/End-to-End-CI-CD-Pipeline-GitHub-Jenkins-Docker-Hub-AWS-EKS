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
