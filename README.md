# Jenkins CI/CD Course Project

A comprehensive Jenkins CI/CD course demonstrating progressive deployment strategies from basic pipelines to advanced Kubernetes deployments with semantic versioning.

## 📋 Overview

This repository contains 6 progressive modules that teach Jenkins CI/CD concepts, starting from basic credential management to production-grade Kubernetes deployments with automated semantic versioning.

## 🏗️ Repository Structure

```
course-jenkins-project/
├── Jenkinsfile                      # Root pipeline (single-server deployment)
├── 01-jenkins-basics/               # Module 1: Credentials & input gates
├── 02-single-server-deployment/     # Module 2: SSH-based deployment
├── 03-lambda-deployment/            # Module 3: AWS Lambda with SAM
├── 04-docker/                       # Module 4: Docker containerization
├── 05-kubernetes/                   # Module 5: Multi-environment K8s
└── 06-advanced-project/             # Module 6: Semantic versioning & quality gates
```

## 📚 Modules

### Module 1: Jenkins Basics
**Location**: `01-jenkins-basics/`

**Learning Objectives**:
- Jenkins credentials management
- Using `withCredentials` block
- Input stages for manual approval
- Basic Python project setup

**Pipeline Stages**:
1. Setup (pip install)
2. Test (pytest)
3. Deployment (manual approval)

**Prerequisites**:
- Jenkins credential: `server-creds` (username/password)

---

### Module 2: Single Server Deployment
**Location**: `02-single-server-deployment/`

**Learning Objectives**:
- SSH-based deployment
- SCP file transfer
- Remote command execution
- Systemd service management

**Pipeline Stages**:
1. Setup
2. Test
3. Package (zip archive)
4. Deploy to Production (SSH/SCP)

**Prerequisites**:
- Jenkins credential: `prod-server-ip` (server IP address)
- Jenkins credential: `ssh-key` (SSH private key)
- Target server with systemd service configured

**Deployment Flow**:
```
Build → Test → Package → SCP → SSH → Unzip → Install → Restart Service
```

---

### Module 3: AWS Lambda Deployment
**Location**: `03-lambda-deployment/`

**Learning Objectives**:
- Serverless deployments
- AWS SAM (Serverless Application Model)
- Lambda function development
- API Gateway integration

**Pipeline Stages**:
1. Setup (install test dependencies)
2. Test
3. Build (SAM build)
4. Deploy (SAM deploy)

**Prerequisites**:
- Jenkins credential: `aws-access-key`
- Jenkins credential: `aws-secret-key`
- AWS SAM CLI installed on Jenkins agent
- AWS account with appropriate permissions

**Lambda Function**:
- Runtime: Python 3.9
- Endpoint: `/hello` (GET)
- Deployment: AllAtOnce

---

### Module 4: Docker
**Location**: `04-docker/`

**Learning Objectives**:
- Docker containerization
- Multi-stage Docker builds
- Docker Hub integration
- Git commit-based image tagging

**Pipeline Stages**:
1. Setup & Test
2. Docker Hub Login
3. Build Docker Image
4. Push to Docker Hub

**Prerequisites**:
- Jenkins credential: `docker-creds` (Docker Hub username/password)
- Docker installed on Jenkins agent

**Image Tagging Strategy**:
```
sanjeevkt720/jenkins-flask-app:${GIT_COMMIT}
```

**Application**:
- Flask web application
- Port: 5000
- Base image: Python 3.12 Alpine

---

### Module 5: Kubernetes
**Location**: `05-kubernetes/`

**Learning Objectives**:
- Kubernetes deployments
- Multi-environment strategy (staging + production)
- Acceptance testing with k6
- kubectl context management
- LoadBalancer services

**Pipeline Stages**:
1. Setup (configure kubeconfig)
2. Test
3. Docker Login
4. Build Docker Image
5. Push Docker Image
6. Deploy to Staging
7. Acceptance Test (k6)
8. Deploy to Production

**Prerequisites**:
- Jenkins credential: `kubeconfig-credentials-id`
- Jenkins credential: `docker-creds`
- Jenkins credential: `aws-access-key`
- Jenkins credential: `aws-secret-key`
- k6 installed on Jenkins agent
- EKS clusters: staging and production

**Kubernetes Resources**:
- **Deployment**: 3 replicas, Flask app
- **Service**: LoadBalancer type, port 5000

**Contexts**:
- Staging: `user@staging.us-east-1.eksctl.io`
- Production: `user@prod.us-east-1.eksctl.io`

---

### Module 6: Advanced Project
**Location**: `06-advanced-project/`

**Learning Objectives**:
- Semantic versioning automation
- Conditional pipeline execution
- Git tag-based deployments
- Code quality gates
- Pull request validation
- Poetry dependency management

**Pipelines**:

#### 1. Code Quality Pipeline (`Jenkinsfile-Code-Quality`)
**Triggers**: Pull requests to main branch

**Stages**:
1. Environment variables
2. PR number detection
3. Setup (Poetry install)
4. Test (pytest)

#### 2. Release Pipeline (`Jenkinsfile-Release`)
**Triggers**: Commits to main branch

**Conditional Logic**:
- **No Git tag**: Create semantic release → Publish
- **Git tag exists**: Build → Docker push → Deploy to production

**Stages**:
1. Check for Git Tag
2. Setup (Poetry)
3. Create Release (if no tag)
4. Build & Deploy (if tag exists)
   - Docker Login
   - Build (multi-tag)
   - Push Image
   - Deploy to Production

**Prerequisites**:
- Jenkins credential: `github-access-token`
- Jenkins credential: `docker-creds`
- Jenkins credential: `kubeconfig-credentials-id`
- Jenkins credential: `aws-access-key`
- Jenkins credential: `aws-secret-key`
- Poetry installed
- Python Semantic Release configured

**Application**: Flask TODO list with add/delete functionality

---

## 🚀 Getting Started

### 1. Jenkins Setup

Install required Jenkins plugins:
```bash
- Pipeline
- Git
- Credentials Binding
- SSH Agent
- Docker Pipeline
- Kubernetes CLI
```

### 2. Configure Credentials

Add the following credentials in Jenkins:

| Credential ID | Type | Description |
|--------------|------|-------------|
| `server-creds` | Username/Password | Server login credentials |
| `prod-server-ip` | Secret Text | Production server IP |
| `ssh-key` | SSH Username with private key | SSH private key for deployment |
| `aws-access-key` | Secret Text | AWS Access Key ID |
| `aws-secret-key` | Secret Text | AWS Secret Access Key |
| `docker-creds` | Username/Password | Docker Hub credentials |
| `kubeconfig-credentials-id` | Secret File | Kubernetes config file |
| `github-access-token` | Secret Text | GitHub personal access token |

### 3. Install Required Tools on Jenkins Agent

```bash
# Python & pip
apt-get install python3 python3-pip

# Docker
apt-get install docker.io

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# AWS SAM CLI
pip3 install aws-sam-cli

# k6 (load testing)
wget https://github.com/grafana/k6/releases/download/v0.47.0/k6-v0.47.0-linux-amd64.tar.gz
tar -xzf k6-v0.47.0-linux-amd64.tar.gz
mv k6-v0.47.0-linux-amd64/k6 /usr/local/bin/

# Poetry
curl -sSL https://install.python-poetry.org | python3 -
```

### 4. Create Jenkins Pipeline Jobs

For each module, create a Pipeline job:
1. New Item → Pipeline
2. Configure → Pipeline section
3. Definition: "Pipeline script from SCM"
4. SCM: Git
5. Repository URL: `<your-repo-url>`
6. Script Path: `<module>/Jenkinsfile`

---

## 🔒 Security Considerations

### Critical Issues

1. **Module 1 - Credential Exposure**:
   - Lines 12-13 echo credentials in plaintext
   - **Fix**: Remove echo statements (for educational purposes only)

2. **SSH StrictHostKeyChecking Disabled**:
   - Multiple pipelines use `-o StrictHostKeyChecking=no`
   - **Risk**: Man-in-the-middle attacks
   - **Fix**: Use proper known_hosts configuration

3. **AWS Credentials in Jenkins**:
   - Consider using IAM roles for Jenkins agents instead
   - Use IRSA (IAM Roles for Service Accounts) for EKS

### Best Practices

✅ Use Jenkins Credentials Store (never hardcode secrets)
✅ Enable audit logging
✅ Implement RBAC for Jenkins users
✅ Scan Docker images for vulnerabilities (Trivy, Snyk)
✅ Use semantic versioning for releases
✅ Implement approval gates for production

---

## 🛠️ Troubleshooting

### Common Issues

**Issue**: `docker: command not found`
```bash
# Ensure Docker is installed and Jenkins user is in docker group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

**Issue**: `kubectl: connection refused`
```bash
# Verify kubeconfig file permissions
chmod 644 $KUBECONFIG
# Test connection
kubectl cluster-info
```

**Issue**: `SAM build failed`
```bash
# Install AWS SAM CLI
pip3 install aws-sam-cli
sam --version
```

**Issue**: `pytest: command not found`
```bash
# Install in virtual environment or globally
pip install pytest
```

**Issue**: Permission denied during SSH deployment
```bash
# Ensure SSH key has correct permissions
chmod 600 ~/.ssh/id_rsa
# Verify key is added to target server
ssh-copy-id user@server
```

---

## 📊 Pipeline Progression

```
Module 1: Basic Pipeline
    ↓
Module 2: Single Server (Traditional)
    ↓
Module 3: Serverless (AWS Lambda)
    ↓
Module 4: Containerization (Docker)
    ↓
Module 5: Orchestration (Kubernetes)
    ↓
Module 6: Advanced (Semantic Versioning)
```

---

## 🎯 Learning Path

1. **Beginners**: Start with Module 1-2
2. **Intermediate**: Modules 3-4
3. **Advanced**: Modules 5-6

---

## 📖 Additional Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [AWS SAM Documentation](https://docs.aws.amazon.com/serverless-application-model/)
- [Python Semantic Release](https://python-semantic-release.readthedocs.io/)

---

## 🤝 Contributing

This is a course project. Feel free to fork and experiment with different deployment strategies.

---

## 📝 License

Educational use only.

---

## 🔗 Quick Links

- **Module 1**: Basic Jenkins → `01-jenkins-basics/Jenkinsfile`
- **Module 2**: Single Server → `02-single-server-deployment/Jenkinsfile`
- **Module 3**: Lambda → `03-lambda-deployment/Jenkinsfile`
- **Module 4**: Docker → `04-docker/Jenkinsfile`
- **Module 5**: Kubernetes → `05-kubernetes/Jenkinsfile`
- **Module 6 (Quality)**: → `06-advanced-project/Jenkinsfile-Code-Quality`
- **Module 6 (Release)**: → `06-advanced-project/Jenkinsfile-Release`
