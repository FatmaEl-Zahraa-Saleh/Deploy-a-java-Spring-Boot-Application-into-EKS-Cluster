# Jenkins CI/CD Pipeline To Deploy Java Spring Boot Application To EKS Cluster

## Pipeline

![Pipeline](/images/CICD-Pipeline-diagram.png)

This project demonstrates a Continuous Integration and Continuous Deployment (CI/CD) pipeline for a Java Spring Boot application using Jenkins. The pipeline automates various stages including linting, testing, static code analysis, building, packaging, artifact deployment, Docker image creation, pushing images to Docker Hub, and deploying to an EKS (Elastic Kubernetes Service) cluster.


## Deployed App on EKS Cluster 

<p align="center">
  <img src="/images/Application-on-EKS-Cluster.png" alt="Full-width Pipeline" style="width: 100%;"/>
</p>

<p align="center">
  <img src="/images/Application-on-EKS-Cluster2.png" alt="Half-width Pipeline 1" style="width: 49%; display: inline-block;"/>
  <img src="/images/Application-on-EKS-Cluster3.png" alt="Half-width Pipeline 2" style="width: 49%; display: inline-block;"/>
</p>



## Overview

The CI/CD pipeline is designed to streamline the development workflow by automating the following stages:

1. **Linting**: Ensures code quality and adherence to coding standards.
2. **Testing**: Runs unit tests to verify the functionality of the application.
3. **Static Code Analysis**: Performs static code analysis to detect code smells and vulnerabilities.
4. **Build and Package**: Compiles and packages the Java Spring Boot application into a JAR file.
5. **Artifact Deployment**: Deploys the JAR artifact to a repository.
6. **Docker Image Creation**: Builds a Docker image for the application.
7. **Push to Docker Hub**: Pushes the Docker image to Docker Hub.
8. **Deploy to EKS Cluster**: Deploys the application to an EKS cluster using Kubernetes.

## Prerequisites

- **Jenkins**: Installed and configured on your server.
- **Docker**: Installed and running on your machine.
- **AWS CLI**: Installed and configured with necessary permissions.
- **kubectl**: Installed and configured to interact with your Kubernetes cluster.
- **Helm**: Installed for managing Kubernetes applications.
- **Java JDK**: Installed for building the Spring Boot application.
- **Gradle**: Installed for managing dependencies and building the project.
- **AWS IAM AUTHENTICATOR** : managing access to AWS EKS clusters. It allows `kubectl` to authenticate to the EKS cluster using AWS IAM credentials.

## Configuring Jenkins for CI/CD Pipeline

### 1. Install Plugins

Ensure the following Jenkins plugins are installed:

- **Git Plugin**
- **Docker Pipeline Plugin**
- **Kubernetes Plugin**
- **SonarQube Scanner Plugin**

### 2. Create a Multibranch Pipeline Job

1. Go to the **Jenkins Dashboard**.
2. Click on **"New Item"** and select **"Multibranch Pipeline"**.
3. Configure the multibranch pipeline job:
   - **Branch Sources**: Add the repository URL and configure branch sources for both the `dev` and `prod` branches.
   - **Credentials**: Ensure that the pipeline has access to the necessary credentials (e.g., Docker Hub credentials) by adding them to the Jenkins credentials store.
   - **Scan Multibranch Pipeline**: Configure the scan settings to automatically detect and build branches (e.g., `dev`, `prod`) based on the Jenkinsfile present in each branch.

### 3. Configure the Jenkinsfile

- Ensure that each branch (`dev` and `prod`) in your repository contains a `Jenkinsfile` that defines the stages and steps for the CI/CD pipeline.
- The `Jenkinsfile` should include stages for building, testing, and deploying the application, and should be configured to handle deployments to the respective environments.

By setting up a multibranch pipeline, Jenkins will automatically manage and build each branch according to the defined `Jenkinsfile`, enabling CI/CD for both development and production workflows.

### 4. Configure AWS EKS Cluster

1. **Create an EKS Cluster** in AWS.
2. **Configure `kubectl`** to use the EKS cluster context.
3. **Install Helm** and configure it to work with your EKS cluster.
4. **Install AWS IAM Authenticator**:
   - Follow the [AWS IAM Authenticator Installation Guide](https://docs.aws.amazon.com/eks/latest/userguide/pod-configuration.html) to install and configure the authenticator.

## Steps to Create and Configure EKS Cluster

### 1. Create and configure EKS Cluster

Run the following `eksctl` command to create an EKS cluster:

```bash
eksctl create cluster \
  --name spring-boot-app-cluster \
  --region us-east-1 \
  --nodegroup-name spring-boot-app-nodes \
  --node-type t2.micro \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 2 \
  --zones us-east-1a,us-east-1b
```
# Deploying to EKS Cluster

This document provides an overview of deploying applications to an Amazon EKS (Elastic Kubernetes Service) cluster. It includes steps for setting up deployments and services in both development and production environments, configuring an Ingress controller, and creating Ingress resources.

## Deployment Overview

### 1. Create Deployments and Services

- **Development Environment**:
  - Deploy applications in the `development` namespace.
  - Create the necessary Kubernetes Deployment and Service resources to manage the application and expose it within the development environment.

- **Production Environment**:
  - Deploy applications in the `production` namespace.
  - Similar to development, create Deployment and Service resources for production to handle live traffic and ensure high availability.

### 2. Set Up Ingress Controller

- **Ingress Controller Installation**:
  - Use Helm to install the NGINX Ingress Controller in the `ingress-nginx` namespace.
  - This controller will manage incoming traffic and route it to the appropriate services based on defined rules.

### 3. Create Ingress Resources

- **Development Namespace**:
  - Create an Ingress resource to route traffic to the application deployed in the `development` namespace.
  - This Ingress resource will handle routing requests to the appropriate service based on URL paths or hostnames.

- **Production Namespace**:
  - Similarly, create an Ingress resource in the `production` namespace to manage traffic routing for the production application.
  - This ensures that requests are directed to the correct service and environment.

## Additional Configuration

### Docker Hub Credentials

To allow the Kubernetes deployments to pull container images from Docker Hub, it is essential to create a Kubernetes Secret that contains Docker Hub credentials. This secret allows Kubernetes to authenticate with Docker Hub and pull images securely.

1. **Create a Kubernetes Secret**:
   - The secret should contain Docker Hub credentials such as the username and password.
   - This secret will be referenced in your Deployment configuration to provide the necessary authentication for image pulls.

By following these steps, you will set up a robust deployment process for your application on EKS, ensuring that both development and production environments are properly configured and accessible through the Ingress controller.



