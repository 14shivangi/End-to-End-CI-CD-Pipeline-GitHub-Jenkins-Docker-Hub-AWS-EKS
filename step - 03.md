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
