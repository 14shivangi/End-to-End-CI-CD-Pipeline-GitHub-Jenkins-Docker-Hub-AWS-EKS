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


