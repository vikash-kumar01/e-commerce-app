# 🛍️ EasyShop - Modern E-commerce Platform

[![Next.js](https://img.shields.io/badge/Next.js-14.1.0-black?style=flat-square&logo=next.js)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0.0-blue?style=flat-square&logo=typescript)](https://www.typescriptlang.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-8.1.1-green?style=flat-square&logo=mongodb)](https://www.mongodb.com/)
[![Redux](https://img.shields.io/badge/Redux-2.2.1-purple?style=flat-square&logo=redux)](https://redux.js.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

EasyShop is a modern, full-stack e-commerce platform built with Next.js 14, TypeScript, and MongoDB. It features a beautiful UI with Tailwind CSS, secure authentication, real-time cart updates, and a seamless shopping experience.

## ✨ Features

- 🎨 Modern and responsive UI with dark mode support
- 🔐 Secure JWT-based authentication
- 🛒 Real-time cart management with Redux
- 📱 Mobile-first design approach
- 🔍 Advanced product search and filtering
- 💳 Secure checkout process
- 📦 Multiple product categories
- 👤 User profiles and order history
- 🌙 Dark/Light theme support

## 🏗️ Architecture

EasyShop follows a three-tier architecture pattern:

### 1. Presentation Tier (Frontend)
- Next.js React Components
- Redux for State Management
- Tailwind CSS for Styling
- Client-side Routing
- Responsive UI Components

### 2. Application Tier (Backend)
- Next.js API Routes
- Business Logic
- Authentication & Authorization
- Request Validation
- Error Handling
- Data Processing

### 3. Data Tier (Database)
- MongoDB Database
- Mongoose ODM
- Data Models
- CRUD Operations
- Data Validation

## 📑 Index

1. PreRequisites
2. Setup & Initialization
    2.1 Provisioning Terraform Infrastructure
    2.2 Jenkins Setup Steps
    2.3 Continuous Deployment (CD) Setup
    2.4 Argo CD Setup
    2.5 Monitoring & Logging Setup
        2.5.1 Install Metric Server
        2.5.2 Monitoring Using kube-prometheus-stack
        2.5.3 Alerting to Slack
        2.5.4 Logging with Elasticsearch, Filebeat, Kibana
3. Congratulations!

## 1. PreRequisites

> [!IMPORTANT]  
> Before you begin setting up this project, make sure the infrastructure is deployed on AWS.

---

## 2. Setup & Initialization

### 2.1 Provisioning Terraform Infrastructure

This project uses [Terraform](https://www.terraform.io/) to provision cloud infrastructure for the e-commerce application.

#### Steps to Provision

1. **Clone the Repository**
    ```bash
    git clone https://github.com/yourusername/e-commerce-app.git
    cd e-commerce-app/terraform
    ```

2. **Initialize Terraform**
    ```bash
    terraform init
    ```

3. **Review and Edit Variables**
    - Edit `variables.tf` or create environment-specific files like `dev.tfvars`, `prod.tfvars`.
    - Ensure your AWS region, account ID, and key names are correct.

4. **Plan the Deployment**
    ```bash
    terraform plan -var-file="dev.tfvars"
    ```

5. **Apply the Deployment**
    ```bash
    terraform apply -var-file="dev.tfvars"
    ```

---

### 2.2 Jenkins Setup Steps

1. **Check if Jenkins Service is Running**
    ```bash
    sudo systemctl status jenkins
    ```

2. **Open Jenkins in Browser**
    - Use your public IP with port 8080:  
      `http://<public_IP>:8080`

3. **Get Initial Admin Password**
    ```bash
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    ```

4. **Start Jenkins (If Not Running)**
    ```bash
    sudo systemctl enable jenkins
    sudo systemctl restart jenkins
    ```

5. **Install Essential Plugins**
    - Navigate to:  
      `Manage Jenkins → Plugins → Available Plugins`
    - Search and install:
        - Docker Pipeline
        - Pipeline View

6. **Set Up Docker & GitHub Credentials in Jenkins (Global Credentials)**
    - GitHub Credentials:
        - Go to:  
          `Jenkins → Manage Jenkins → Credentials → (Global) → Add Credentials`
        - Kind: Username with password
        - ID: github-credentials
    - DockerHub Credentials:
        - Kind: Username with password
        - ID: docker-hub-credentials

7. **Jenkins Shared Library Setup**
    - Go to:  
      `Jenkins → Manage Jenkins → Configure System`
    - Scroll to Global Pipeline Libraries section
    - Add a New Shared Library:
        - Name: Shared
        - Default Version: main
        - Project Repository URL: `https://github.com/<your user-name>/jenkins-shared-libraries`

8. **Setup Pipeline**
    - Create New Pipeline Job
        - Name: EasyShop
        - Type: Pipeline
    - In General:
        - Description: EasyShop
        - Check the box: GitHub project
        - GitHub Repo URL: `https://github.com/<your user-name>/mrdevops-e-commerce-app`
    - In Trigger:
        - Check the box: GitHub hook trigger for GITScm polling
    - In Pipeline:
        - Definition: Pipeline script from SCM
        - SCM: Git
        - Repository URL: `https://github.com/<your user-name>/mrdevops-e-commerce-app`
        - Credentials: github-credentials
        - Branch: master
        - Script Path: Jenkinsfile

9. **Fork Required Repos**
    - Fork App Repo:
        - Open the Jenkinsfile
        - Change the DockerHub username to yours
    - Fork Shared Library Repo:
        - Edit `vars/update_k8s_manifest.groovy`
        - Update with your DockerHub username

10. **Setup Webhook**
    - In GitHub:
        - Go to Settings → Webhooks
        - Add a new webhook pointing to your Jenkins URL
        - Select: GitHub hook trigger for GITScm polling in Jenkins job

11. **Trigger the Pipeline**
    - Click Build Now in Jenkins

---

### 2.3 Continuous Deployment (CD) Setup

1. **Install Required Tools**
    - kubectl
    - AWS CLI

2. **SSH into Bastion Server**
    - Connect to your Bastion EC2 instance via SSH.

3. **Configure AWS CLI on Bastion Server**
    ```bash
    aws configure
    ```

4. **Update Kubeconfig for EKS**
    ```bash
    aws eks update-kubeconfig --region us-east-1 --name mrdevops-eks-cluster
    ```

5. **Install AWS Application Load Balancer Controller**
    - Refer: https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

6. **Install EBS CSI Driver**
    - Refer: https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html#eksctl_store_app_data

---

### 2.4 Argo CD Setup

1. **Create Namespace for Argo CD**
    ```bash
    kubectl create namespace argocd
    ```

2. **Install Argo CD using Helm**
    ```bash
    helm repo add argo https://argoproj.github.io/argo-helm
    helm install my-argo-cd argo/argo-cd --version 8.0.10
    ```

3. **Get and Edit Values File**
    ```bash
    helm show values argo/argo-cd > argocd-values.yaml
    ```
    - Edit the values file as per your domain and ingress settings.

4. **Upgrade the Helm Chart**
    ```bash
    helm upgrade my-argo-cd argo/argo-cd -n argocd -f my-values.yaml
    ```

5. **Add Route53 Record**
    - Add the record in Route53 for your domain with the load balancer DNS.

6. **Access Argo CD in Browser**

7. **Retrieve Argo CD Admin Secret**
    ```bash
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    ```

8. **Login and Change Password in Argo CD UI**

9. **Deploy Your Application in Argo CD GUI**
    - Fill in Application Name, Project Name, Sync Policy, Repo URL, Path, Cluster URL, Namespace, etc.

10. **Update Ingress Settings and Image Tag in Kubernetes Manifests**

11. **Add Route53 Record for Your Site**

12. **Access Your Site**

---

### 2.5 Monitoring & Logging Setup

#### 2.5.1 Install Metric Server

1. **Install Metric Server via Helm**
    - Refer: https://artifacthub.io/packages/helm/metrics-server/metrics-server

2. **Verify Metric Server**
    ```bash
    kubectl get pods -w
    kubectl top pods
    ```

#### 2.5.2 Monitoring Using kube-prometheus-stack

1. **Create Namespace**
    ```bash
    kubectl create ns monitoring
    ```

2. **Install kube-prometheus-stack via Helm**
    - Refer: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

3. **Verify Deployment**
    ```bash
    kubectl get pods -n monitoring
    ```

4. **Get and Edit Helm Values**
    ```bash
    helm show values prometheus-community/kube-prometheus-stack > kube-prom-stack.yaml
    ```
    - Edit values for Grafana, Prometheus, Alertmanager ingress and annotations.

    **Example Grafana Ingress:**
    ```yaml
    ingressClassName: alb
    annotations:
      alb.ingress.kubernetes.io/group.name: easyshop-app-lb
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-south-1:876997124628:certificate/b69bb6e7-cbd1-490b-b765-27574080f48c
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/ssl-redirect: '443'
    hosts:
      - grafana.devopsdock.site
    ```

    **Example Prometheus Ingress:**
    ```yaml
    ingressClassName: alb
    annotations:
      alb.ingress.kubernetes.io/group.name: easyshop-app-lb
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-south-1:876997124628:certificate/b69bb6e7-cbd1-490b-b765-27574080f48c
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/ssl-redirect: '443'
    hosts:
      - prometheus.devopsdock.site
        paths:
        - /
        pathType: Prefix
    ```

    **Example Alertmanager Ingress:**
    ```yaml
    ingressClassName: alb
    annotations:
      alb.ingress.kubernetes.io/group.name: easyshop-app-lb
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/backend-protocol: HTTP
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/ssl-redirect: '443'
    hosts:
      - alertmanager.devopsdock.site
    paths:
      - /
    pathType: Prefix
    ```

5. **Upgrade the Chart**
    ```bash
    helm upgrade my-kube-prometheus-stack prometheus-community/kube-prometheus-stack -f kube-prom-stack.yaml -n monitoring
    ```

6. **Get Grafana Admin Password**
    ```bash
    kubectl --namespace monitoring get secrets my-kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
    ```

#### 2.5.3 Alerting to Slack

1. **Create Slack Workspace and Channel**
2. **Create Slack App and Incoming Webhook**
3. **Edit Alertmanager Helm Values with Slack Webhook**
    ```yaml
    config:
      global:
        resolve_timeout: 5m
      route:
        group_by: ['namespace']
        group_wait: 30s
        group_interval: 5m
        repeat_interval: 12h
        receiver: 'slack-notification'
        routes:
        - receiver: 'slack-notification'
          matchers:
            - severity = "critical"
      receivers:
      - name: 'slack-notification'
        slack_configs:
          - api_url: 'https://hooks.slack.com/services/your/webhook/url'
            channel: '#alerts'
            send_resolved: true
      templates:
      - '/etc/alertmanager/config/*.tmpl'
    ```
4. **Upgrade the Chart**
    ```bash
    helm upgrade my-kube-prometheus-stack prometheus-community/kube-prometheus-stack -f kube-prom-stack.yaml -n monitoring
    ```

#### 2.5.4 Logging with Elasticsearch, Filebeat, Kibana

1. **Install Elasticsearch via Helm**
    ```bash
    helm repo add elastic https://helm.elastic.co -n logging
    helm install my-elasticsearch elastic/elasticsearch --version 8.5.1 -n logging
    ```

2. **Create StorageClass for Elasticsearch**
    - Apply `storageclass.yaml`:
    ```yaml
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: ebs-aws
      annotations:
        storageclass.kubernetes.io/is-default-class: "true"
    provisioner: ebs.csi.aws.com
    reclaimPolicy: Delete
    volumeBindingMode: WaitForFirstConsumer
    ```

3. **Get and Edit Elasticsearch Helm Values**
    ```bash
    helm show values elastic/elasticsearch > elasticsearch.yaml
    ```
    - Edit values for replicas, master nodes, etc. Example:
    ```yaml
    replicas: 1
    minimumMasterNodes: 1
    clusterHealthCheckParams: "wait_for_status=yellow&timeout=1s"
    ```

4. **Upgrade Elasticsearch Chart**
    ```bash
    helm upgrade my-elasticsearch elastic/elasticsearch -f elasticsearch.yaml -n logging
    ```

5. **Install Filebeat via Helm**
    ```bash
    helm install my-filebeat elastic/filebeat --version 8.5.1 -n logging
    ```

6. **Get and Edit Filebeat Helm Values**
    ```bash
    helm show values elastic/filebeat > filebeat.yaml
    ```
    - Edit values to ship EasyShop logs. Example:
    ```yaml
    filebeatConfig:
      filebeat.yml: |
        filebeat.inputs:
        - type: container
          paths:
            - /var/log/containers/*easyshop*.log
    ```

7. **Install Kibana via Helm**
    ```bash
    helm install my-kibana elastic/kibana --version 8.5.1 -n logging
    ```

8. **Get and Edit Kibana Helm Values**
    ```bash
    helm show values elastic/kibana > kibana.yaml
    ```
    - Edit ingress settings. Example:
    ```yaml
    ingress:
      enabled: true
      className: "alb"
      pathtype: Prefix
      annotations:
        alb.ingress.kubernetes.io/group.name: easyshop-app-lb
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/target-type: ip
        alb.ingress.kubernetes.io/backend-protocol: HTTP
        alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-south-1:876997124628:certificate/b69bb6e7-cbd1-490b-b765-27574080f48c
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
        alb.ingress.kubernetes.io/ssl-redirect: '443'
      hosts:
        - host: logs-kibana.devopsdock.site
          paths:
            - path: /
    ```

9. **Upgrade Kibana Chart**
    ```bash
    helm upgrade my-kibana elastic/kibana -f kibana.yaml -n logging
    ```

10. **Add Route53 Records for Logging Endpoints**

11. **Retrieve Elasticsearch Secret for Kibana**
    ```bash
    kubectl get secrets --namespace=logging elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
    ```

12. **Configure Filebeat to Ship EasyShop Logs**
    - Edit `filebeatConfig` in values.

13. **Upgrade Filebeat Chart and Verify Logs in Kibana**

---

## 3. Congratulations!

Your EasyShop platform is now fully deployed and operational!