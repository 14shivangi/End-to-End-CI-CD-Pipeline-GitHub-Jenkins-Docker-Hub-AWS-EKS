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

### Explanation

- `LoadBalancer` creates an external AWS Elastic Load Balancer (ELB).
- `selector` connects the service with the application Pods.
- `port: 80` exposes the application externally.
- `targetPort: 80` forwards traffic to the container's port.

---

# DockerHub Repository Setup

## Create a DockerHub Repository

1. Log in to DockerHub.
2. Navigate to **Repositories**.
3. Click **Create Repository**.
4. Enter the following details:

| Field | Value |
|---------|---------|
| Repository Name | `<docker-repo>` |
| Visibility | Public |

---

# Configure DockerHub Credentials in Jenkins

Navigate to:

```text
Jenkins
└── Manage Jenkins
    └── Credentials
        └── Add Credentials
```

Configure the credentials:

| Field | Value |
|---------|---------|
| Kind | Username with Password |
| Username | DockerHub Username |
| Password | DockerHub Password |
| ID | dockerhub |
| Description | DockerHub Credentials |

---

# Purpose of DockerHub Credentials

These credentials allow Jenkins to:

- Authenticate with DockerHub.
- Push Docker images automatically after a successful build.
- Pull images during Kubernetes deployments.
- Enable a complete CI/CD workflow between GitHub, Jenkins, DockerHub, and Amazon EKS.

---
# Jenkins Pipeline Setup for EKS Deployment

## Install AWS Credentials Plugin

Navigate to:

Jenkins → Manage Jenkins → Plugins → Available Plugins

Search for:

aws-cred

Install the plugin.

---

## Configure AWS Credentials

Navigate to:

Jenkins → Manage Jenkins → Credentials → Add Credentials

Provide:

- Credentials ID: `aws-cred`
- AWS Access Key ID
- AWS Secret Access Key

Save the credentials.

---

## Create a Jenkins Pipeline Job

1. Create a new Jenkins Job.
2. Select **Pipeline**.
3. Configure the GitHub repository URL.
4. Enable **GitHub Webhook Trigger**.
5. Add the pipeline script.

---
## Sample Jenkinsfile

```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your-dockerhub-username/app"
        IMAGE_TAG    = "${BUILD_NUMBER}"

        AWS_REGION   = "us-east-2"
        CLUSTER_NAME = "eks-cluster"

        K8S_DIR      = "k8s"
    }

    stages {

        stage('Clone Code') {
            steps {
                git 'https://github.com/your-repository.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                docker tag $DOCKER_IMAGE : $IMAGE_TAG $DOCKER_IMAGE : latest
                """
            }
        }
        stage('Push to DockerHub') {
    steps {

        withCredentials([
            usernamePassword(
                credentialsId: 'dockerhub',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
            )
        ]) {

                sh """
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                docker push ${DOCKER_IMAGE}:latest
                """
                }
            }
        }
        stage('Configure AWS & EKS') {

     steps {

        withCredentials([
            [
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'aws-cred'
            ]]) {

                sh """
                export AWS_DEFAULT_REGION=${AWS_REGION}

                aws sts get-caller-identity

                aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}
                """
                }
            }
        }
        stage('Deploy to EKS') {

    steps {

        withCredentials([
            [
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'aws-cred'
            ]
        ]) {

                sh """

                export AWS_DEFAULT_REGION=${AWS_REGION}

                kubectl apply -f ${K8S_DIR}/ --validate=false

                kubectl set image deployment/${APP_DEPLOYMENT} \
                ${APP_CONTAINER}=${DOCKER_IMAGE}:${IMAGE_TAG}

                kubectl rollout status deployment/${APP_DEPLOYMENT}

                """
                }
            }
        }
    }
    post {

        success {
            echo "Deployment Successful"
        }

        failure {
            echo "Deployment Failed"
        }
    }
}

----
# Access Application Using DNS

## Verify Kubernetes Service

Check the running pods:

```bash
kubectl get pods
```

Check the LoadBalancer service:

```bash
kubectl get svc
```

Example Output:

```text
NAME          TYPE           CLUSTER-IP      EXTERNAL-IP
app-service   LoadBalancer   10.x.x.x        abc.elb.amazonaws.com
```

Copy the DNS name from the `EXTERNAL-IP` column and open it in a browser.

---

## Configure Custom Domain with GoDaddy

### Add a DNS Record

Navigate to:

```text
GoDaddy
 → DNS Management
 → DNS Records
 → Add New Record
```

Configure:

```text
Type   : CNAME
Name   : www
Value  : <LoadBalancer-DNS>
TTL    : 1/2 Hour
```

Example:

```text
Type   : CNAME
Name   : www
Value  : abc123.us-east-2.elb.amazonaws.com
TTL    : 30 Minutes
```

Save the record and wait for DNS propagation.

---

## Verify Domain

Open:

```text
www.yourdomain.com
```

The request will be routed to the AWS Load Balancer and then to the Kubernetes Pods running inside Amazon EKS.

---

# Developer Workflow

## Update Application

Edit the application file:

```bash
vim index.html
```

Make the required changes and save:

```vim
:wq!
```

---

## Commit Changes to GitHub

Check repository status:

```bash
git status
```

Add modified files:

```bash
git add index.html
```

Commit changes:

```bash
git commit -m "Updated index.html"
```

Push code:

```bash
git push origin master
```

Authenticate using GitHub Username and Personal Access Token when prompted.

---

## CI/CD Process

Once code is pushed:

1. GitHub Webhook triggers Jenkins.
2. Jenkins starts a new pipeline build.
3. Docker image is rebuilt.
4. Image is pushed to DockerHub with a new tag.
5. Jenkins deploys the new image to Amazon EKS.
6. Kubernetes updates running Pods automatically.

---


# Access Running Kubernetes Pods

## List Pods

```bash
kubectl get pods
```

Example:

```text
NAME                              READY   STATUS
app-deployment-7b5d4b8f7c-abcde   1/1     Running
app-deployment-7b5d4b8f7c-fghij   1/1     Running
```

---

## Connect to a Pod

Open an interactive shell inside a running pod:

```bash
kubectl exec -it <pod-name> -- /bin/bash
```

Example:

```bash
kubectl exec -it app-deployment-7b5d4b8f7c-abcde -- /bin/bash
```

---

## Install Vim (If Not Available)

```bash
apt update -y
apt install -y vim
```

---

## Edit Application File

Open the web page file:

```bash
vim /var/www/html/index.html
```

Make changes and save:

```vim
:wq!
```

Exit the editor:

```bash
exit
```

---

## Verify Changes

Check running pods again:

```bash
kubectl get pods
```

Connect to another pod if multiple replicas exist:

```bash
kubectl exec -it <pod-name> -- /bin/bash
```

Edit:

```bash
vim /var/www/html/index.html
```

Update content and save:

```vim
:wq!
```

---

## Understanding Replica Behavior

If your Deployment has multiple replicas:

```yaml
replicas: 2
```

Kubernetes creates multiple Pods.

Example:

```text
Pod-1 → Region A / Timezone A
Pod-2 → Region B / Timezone B
```

Changes made manually inside one Pod affect only that Pod.

If the Pod restarts, the changes are lost because containers are ephemeral.

---

## Recommended Approach

Instead of editing files directly inside Pods:

1. Modify source code locally.
2. Commit changes to GitHub.
3. Push code to repository.
4. Trigger Jenkins CI/CD pipeline.
5. Build a new Docker image.
6. Deploy updated image to Amazon EKS.

This ensures all replicas receive the same version of the application.

---

## Commands Summary

```bash
kubectl get pods

kubectl exec -it <pod-name> -- /bin/bash

apt update -y

apt install -y vim

vim /var/www/html/index.html

exit
```

## Tools & Services Used

- Kubernetes
- Amazon EKS
- Docker Containers
- Jenkins
- GitHub
- DockerHub
- Vim
- Linux
