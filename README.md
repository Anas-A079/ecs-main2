# Assignment 1 - Open Source App Hosted on ECS with Terraform 🚀

This project is based on Amazon's Threat Composer Tool, an open-source application used for threat modelling and security analysis in cloud environments.

Dashboard:  
https://awslabs.github.io/threat-composer/workspaces/default/dashboard

---

## Project Overview 🧭

This project demonstrates a full end-to-end DevOps workflow:

- Containerising an application using Docker
- Hosting images in Amazon ECR
- Deploying workloads using AWS ECS (Fargate)
- Exposing services via an Application Load Balancer (ALB)
- Automating infrastructure using Terraform (IaC)
- Preparing CI/CD automation with GitHub Actions

The goal is to simulate a real-world production deployment pipeline with scalability, repeatability, and automation.

---

## Project Progress 🚧

---

### ✅ Phase 1: ClickOps (Manual AWS Deployment)

In the initial phase, all infrastructure was created manually using the AWS Console to understand how each component works together.

#### Application Layer
- Application runs locally with `/health` endpoint returning:
  ```json
  {"status":"ok"}
# ecs-main2
