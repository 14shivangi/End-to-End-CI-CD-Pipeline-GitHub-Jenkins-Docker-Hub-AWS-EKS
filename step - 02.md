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
