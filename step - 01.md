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
