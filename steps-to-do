#### What Happens in This Step?
- Developer prepares the application source code.
- Dockerfile is created to containerize the Apache web application.
- Source code is stored in GitHub.
- GitHub becomes the source repository for the CI/CD pipeline.

#### Architecture
Developer  -->  Ubuntu Server    -->   Dockerfile Created   -->  GitHub Repository

Step 1: Developer Server Setup

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

#### What Happens in This Step?
- Jenkins is installed on a dedicated EC2 instance.
- Java is installed because Jenkins requires it.
- Docker is installed so Jenkins can build Docker images.
- Jenkins is added to the Docker group, allowing it to execute Docker commands without permission issues.
- Port 8080 is opened to access the Jenkins web interface.

Developer
    │
    ▼
GitHub Repository
    │
    ▼
Jenkins Master Server
    ├── Java
    ├── Git
    └── Docker
    
```text
Settings
  └── Webhooks
       └── Add Webhook
```


# Step 2: Jenkins Master Server Setup

Launch a new Ubuntu EC2 instance and connect to it.

## Switch to Root User

```bash
sudo su -
```

---

## Update Packages

```bash
apt-get update -y
```

---

## Install Java

```bash
apt install fontconfig openjdk-21-jre -y
```

---

## Add Jenkins Repository Key

```bash
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
```

---

## Add Jenkins Repository

```bash
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | \
tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```

---

## Install Jenkins

```bash
apt update -y

apt install jenkins -y
```

---

## Start Jenkins Service

```bash
systemctl start jenkins
```

---

## Verify Jenkins User

```bash
id jenkins
```

---

## Grant Sudo Access to Jenkins

```bash
vim /etc/sudoers
```

Add the following line:

```text
jenkins ALL=(ALL) NOPASSWD:ALL
```

Save and Exit:

```bash
:wq!
```

---

## Install Git

```bash
apt install git -y
```

---

## Install Docker

```bash
apt install docker.io -y
```

Start Docker:

```bash
systemctl start docker
```

Enable Docker:

```bash
systemctl enable docker
```

---

## Add Jenkins User to Docker Group

```bash
usermod -aG docker jenkins
```

---

## Restart Services

```bash
systemctl restart jenkins

systemctl restart docker
```

---

## Configure Security Group

Allow inbound traffic on:

```text
Port 8080 - Jenkins Dashboard
```

Source:

```text
Anywhere (0.0.0.0/0)
```

---

## Access Jenkins Dashboard

Open:

```text
http://<JENKINS_PUBLIC_IP>:8080
```

----
## Configure Jenkins and Prepare AWS EKS

## Unlock Jenkins

Retrieve the initial admin password:

```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy the password and paste it into the Jenkins setup screen.

---

## Complete Jenkins Setup

1. Install Suggested Plugins
2. Create Admin User

Provide:

```text
Username
Password
Full Name
Email Address
```

Click **Save and Continue**.

---

## Configure GitHub Webhook

In your GitHub repository:

Payload URL:

```text
http://<JENKINS_PUBLIC_IP>:8080/github-webhook/
```

Content Type:

```text
application/json
```

Save the webhook.

---
### What Happens in This Step?
- Jenkins dashboard is unlocked and configured.
- GitHub Webhook is connected to Jenkins.
- An IAM user is created to allow Jenkins to access AWS services.
- AWS CLI is configured on the Jenkins server.
- An Amazon EKS cluster is created for Kubernetes deployments.

# Create IAM User for Jenkins

Login to AWS Console:

```text
IAM
 └── Users
      └── Create User
```

Attach Policy:

```text
AdministratorAccess
```

Create the user.

---

## Generate Access Keys

```text
IAM User
 └── Security Credentials
      └── Create Access Key
```

Copy:

```text
Access Key ID
Secret Access Key
```

---

## Configure AWS CLI on Jenkins Server

```bash
aws configure
```

Provide:

```text
Access Key ID
Secret Access Key
Default Region
Output Format
```

---

# Create Amazon EKS Cluster

AWS Console:

```text
EKS
 └── Create Cluster
```

Configuration used in notes:

```text
Custom Configuration
Disable Auto Mode
Name
Create Recommended Role
Version: 1.33
Add-ons

```

Then create

# Step 4: AWS CLI Installation and EKS Node Group Setup

## Install AWS CLI on Jenkins 

Download AWS CLI:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
```

Install unzip package:

```bash
apt update -y
apt install unzip -y
```

Extract AWS CLI:

```bash
unzip awscliv2.zip
```

Navigate to extracted directory:

```bash
ls
cd /aws
```

Install AWS CLI:

```bash
/root/aws/install
```

Verify Installation:

```bash
aws --version
```

---

## Configure AWS CLI

```bash
aws configure
```

Provide:

```text
AWS Access Key ID -
AWS Secret Access Key -
Default Region Name -
Default Output Format -
```

---

# Create Node Group for EKS Cluster

AWS Console:

```text
EKS
 └── Clusters
      └── Node Group
```

Configuration:

```text
Node Group Name
Node IAM Role
Instance Type
Desired Capacity - 1
Minimum Nodes - 1
Maximum Nodes - 5
```

Proceed with the default networking configuration and create the node group.

---

# Verify Node Group Creation

Wait until:

```text
Status = Active
```

---

# Configure Security Groups

Ensure required inbound rules are configured.

Allow:

```text
SSH       → Port 22
HTTP      → Port 80
HTTPS     → Port 443
Jenkins   → Port 8080
Kubernetes Communication Ports
```

Source:

```text
0.0.0.0/0
```

(Use stricter rules in production environments.)

---


Confirm:

```text
Node Group = Active
Nodes Running Successfully
```

## Installation eksctl and kubectl

## Install EKSCTL on Amazon Linux 2023

Download and install eksctl:

```bash
curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp

mv /tmp/eksctl /usr/local/bin

eksctl version
```

Verify installation:

```bash
eksctl version
```

---

## Install kubectl

Download kubectl:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Make executable:

```bash
chmod +x kubectl
```

Move to system path:

```bash
mv kubectl /usr/local/bin/
```

Verify installation:

```bash
kubectl version --client
```

---

# Connect Jenkins Server to EKS Cluster

Update kubeconfig:

```bash
aws eks update-kubeconfig \
--region us-east-2 \
--name <cluster-name>
```

Example:

```bash
aws eks update-kubeconfig \
--region us-east-2 \
--name eks-cluster
```

---

# Verify Cluster Connection

Check Nodes:

```bash
kubectl get nodes
```

Expected Output:

```text
NAME              STATUS   ROLES    AGE
ip-xxx-xxx-xxx    Ready    <none>   xxm
```

---

# Verify Kubernetes Access

```bash
kubectl get pods -A
```

Check namespaces:

```bash
kubectl get ns
```

---

# Jenkins Server Ready

At this point Jenkins can:

- Access AWS EKS Cluster
- Deploy Kubernetes Resources
- Create Deployments
- Create Services
- Update Container Images
- Perform Automated CI/CD Deployments
