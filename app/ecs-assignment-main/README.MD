<div align="center">
    <img src="./images/coderco.jpg" alt="CoderCo" width="300"/>
</div>

# CoderCo Assignment 1 - Open Source App Hosted on ECS with Terraform 🚀

This project is based on Amazon's Threat Composer Tool, an open source tool designed to facilitate threat modeling and improve security assessments. You can explore the tool's dashboard here: [Threat Composer Tool](https://awslabs.github.io/threat-composer/workspaces/default/dashboard)

---

## Task/Assignment 📝

* Create your own repository and complete the task there. You may create a `app` in your repo and copy all the files in this directory into it. Or alternatively, you can use this directory as is. Your choice.

* Your task will be to create a container image for the app, push it to ECR (recommended) or DockerHub. Ideally, you should use a CI/CD pipeline to build, test, and push the container image.

* Deploy the app on ECS using Terraform. All the resources should be provisioned using Terraform. Use TF modules.

* Make sure the app is live on `https://tm.<your-domain>` or `https://tm.labs.<your-domain>`

* App must use HTTPS. Hosted on ECS. Figure out the rest. Once app is live, add screenshots to the README.md file.

* Add architecture diagram of how the infrastructure is setup. (Use Lucidchart or draw.io or mermaid) You are free to use any diagramming tool.

---

## Project Progress 🚧

### ✅ Completed (ClickOps Phase)

* Application runs locally with `/health` endpoint returning `{"status":"ok"}`
* Containerised application using Docker (multi-stage build)
* Built and pushed Docker image to Amazon ECR
* Created ECS Cluster using AWS Fargate
* Created Task Definition and Service
* Configured Application Load Balancer (ALB)
* Connected ALB → Target Group → ECS Tasks
* Application successfully accessible via public ALB DNS

```bash
curl http://<alb-dns>/health
# {"status":"ok"}
```

---

### 🔜 In Progress (Terraform Phase)

* Rebuilding entire infrastructure using Terraform (IaC)
* Creating modular Terraform structure (VPC, ECS, ALB, ECR, IAM)
* Automating infrastructure provisioning
* Replacing manual (ClickOps) setup with reproducible code

---

### ⏳ Upcoming

* CI/CD pipeline (GitHub Actions)

  * Build Docker image
  * Push to ECR
  * Deploy Terraform automatically

* HTTPS setup using AWS Certificate Manager (ACM)

* Custom domain configuration via Route 53

* Final production endpoint:

```
https://tm.<your-domain>
```

---

## Architecture Overview 🏗️

Current (ClickOps Deployment):

```
User
  ↓
Application Load Balancer (HTTP)
  ↓
Target Group
  ↓
ECS Service (Fargate)
  ↓
ECS Task (Container)
  ↓
Nginx
  ↓
Application (/health)
```

Terraform version of this architecture will fully automate the above infrastructure.

---

## Local app setup 💻

```bash
yarn install
yarn build
yarn global add serve
serve -s build

# yarn start
http://localhost:3000/workspaces/default/dashboard

## or
yarn global add serve
serve -s build
```

---

## Useful links 🔗

* https://registry.terraform.io/providers/hashicorp/aws/latest/docs
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
* https://www.terraform.io/docs/index.html
* https://docs.aws.amazon.com/ecs/latest/userguide/what-is-ecs.html

---

## Advice & Tips 💡

* Understand the manual deployment (ClickOps) before automating with Terraform
* Keep infrastructure modular and reusable
* Use best practices for Docker images (small size, non-root user)
* Use least-privilege IAM roles
* Test locally before deploying
* Keep README updated with screenshots and architecture diagrams

---

## Final Deliverables 📦

* Working application deployed on ECS
* Infrastructure defined using Terraform
* CI/CD pipeline for automated deployments
* HTTPS-enabled application with custom domain
* Complete documentation and architecture diagram
