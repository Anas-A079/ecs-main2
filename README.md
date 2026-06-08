# 🏫 School Equipment Borrowing System

> A frontend-only web application for managing school equipment borrowing requests — containerised with Docker, deployed on AWS ECS Fargate, and provisioned with Terraform and GitHub Actions.

**Live site:** [https://tm.networking-lab.uk](https://tm.networking-lab.uk)

---

## 📌 Overview

The **School Equipment Borrowing System** is a **frontend application with no backend**. Students and teachers submit borrowing requests through a web form; an admin dashboard lets authorised users approve, deny, or delete requests and set return dates.

All request data is stored in the browser using **`localStorage`** — there is no server-side database, no REST API, and no authentication layer. PHP is used only to **serve the HTML pages**; all application logic runs in **vanilla JavaScript** on the client.

The AWS infrastructure (ECS, ALB, Route 53, ACM, ECR) exists to **host and deliver** this static frontend reliably over HTTPS — not to provide application backend services.

---

## 🏗️ Architecture

```
User
 └──▶ Route 53 (DNS)
        └──▶ ALB (HTTPS via ACM)
               └──▶ ECS Fargate (Apache + PHP — page serving only)
                          │
                          └──▶ Amazon ECR (Docker image registry)

Browser (client-side)
 └──▶ localStorage (all request data lives here)

Infrastructure provisioned with Terraform (modular)
CI/CD via GitHub Actions + AWS OIDC (keyless auth)
Region: eu-north-1
```

### AWS Services Used

| Service | Role |
|---|---|
| **ECS Fargate** | Hosts the Apache + PHP container (serves frontend files) |
| **ECR** | Private Docker image registry |
| **ALB** | HTTPS load balancing and routing |
| **Route 53** | DNS management |
| **ACM** | SSL/TLS certificate provisioning |
| **IAM (OIDC)** | Keyless GitHub Actions authentication |

---

## ✨ Features

- 📋 **Borrowing Request Form** — Students and teachers submit equipment requests
- 🛠️ **Admin Dashboard** — Centralised view of all requests
- ✅ **Approve / Deny / Delete** — Full request lifecycle management
- 📅 **Return Date Setting** — Admins assign expected return dates on approval
- 🔍 **Search & Filter** — Filter requests by status, name, or equipment
- 📊 **Summary Statistics** — Live counts of pending, approved, and denied requests
- 📱 **Responsive UI** — Mobile-friendly layout
- 💾 **localStorage Persistence** — All data stored client-side in the browser

---

## 🧰 Tech Stack

### Frontend (application)
- HTML5 / CSS3
- Vanilla JavaScript (ES6+)
- Browser `localStorage`
- PHP 8 *(page serving only — no backend logic)*

### Infrastructure (IaC)
- Terraform (modular)
- AWS ECS Fargate, ECR, ALB, Route 53, ACM

### CI/CD
- GitHub Actions
- AWS OIDC (no static credentials)
- Docker

---

## 📁 Folder Structure

```
ECS-project-NewApp/
├── .github/
│   └── workflows/
│       ├── deploy.yml          # Build, push, and deploy to ECS
│       └── ecs-destroy.yml     # Teardown workflow
│
├── Infra/
│   ├── main.tf                 # Root Terraform config
│   ├── provider.tf             # AWS provider
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Stack outputs
│   ├── terraform.tfvars        # Environment-specific values
│   └── modules/
│       ├── vpc/                # VPC, subnets, routing
│       ├── ecr/                # ECR repository
│       ├── alb/                # Load balancer + HTTPS listener + ACM
│       ├── ecs/                # Fargate cluster, task def, service
│       └── route53/            # DNS records
│
├── school-equipment/
│   ├── Dockerfile              # Apache + PHP image (port 8080)
│   ├── health.php              # ALB health check endpoint
│   ├── index.php               # Student/teacher borrowing form
│   ├── admin.php               # Admin dashboard
│   └── assets/
│       ├── css/
│       │   └── style.css       # Global styles
│       ├── js/
│       │   ├── app.js          # Request submission logic
│       │   ├── admin.js        # Admin dashboard logic
│       │   └── storage.js      # localStorage abstraction layer
│       └── images/             # Screenshots and demo media
│           ├── SchoolBorrowRequest.png
│           ├── SchoolAdminPanel.png
│           ├── EcsDeploy.png
│           ├── EcsDestroy.png
│           └── Screencast from 2026-06-08 01-39-57.webm
│
└── README.md
```

---

## 🖥️ Run Locally

### Prerequisites
- Docker installed and running

### Steps

```bash
# Clone the repository
git clone https://github.com/Anas-A079/ecs-main2.git
cd ECS-project-NewApp/school-equipment

# Build the Docker image
docker build -t school-equipment .

# Run the container (app listens on 8080 inside the container)
docker run -p 8080:8080 school-equipment
```

Open your browser at **http://localhost:8080**

> Admin panel: **http://localhost:8080/admin.php**

---

## 🚀 Deployment

### CI/CD Flow (GitHub Actions)

```
git push → GitHub Actions triggered
              │
              ├── 1. Authenticate to AWS via OIDC
              ├── 2. Build Docker image
              ├── 3. Push image to Amazon ECR
              ├── 4. Run Terraform plan + apply
              ├── 5. Update ECS Fargate service
              └── 6. ALB health check on /health
```

### Manual Infrastructure Deployment

```bash
cd Infra/

terraform init
terraform plan
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

> Alternatively, trigger the `ecs-destroy.yml` workflow from GitHub Actions.

### Required GitHub Secret

| Secret | Description |
|---|---|
| `AWS_ROLE_TO_ASSUME` | IAM role ARN for OIDC authentication from GitHub Actions |

---

## 📸 Screenshots & Demo

All media lives in `school-equipment/assets/images/`.

### Application UI

**Borrowing Request Form** (`SchoolBorrowRequest.png`)

![Borrowing request form](school-equipment/assets/images/SchoolBorrowRequest.png)

**Admin Dashboard** (`SchoolAdminPanel.png`)

![Admin dashboard](school-equipment/assets/images/SchoolAdminPanel.png)

### CI/CD Workflows

**ECS Deploy workflow** (`EcsDeploy.png`)

![GitHub Actions ECS Deploy workflow](school-equipment/assets/images/EcsDeploy.png)

**ECS Destroy workflow** (`EcsDestroy.png`)

![GitHub Actions ECS Destroy workflow](school-equipment/assets/images/EcsDestroy.png)

### Demo walkthrough

A screen recording of the application in use is included:

🎬 [Screencast from 2026-06-08 01-39-57.webm](school-equipment/assets/images/Screencast%20from%202026-06-08%2001-39-57.webm)

---

## 🔒 Security Notes

- **No static AWS credentials** — GitHub Actions authenticates via AWS OIDC (IAM Identity Provider)
- **HTTPS enforced** — All traffic routed through ALB with ACM-managed TLS certificate
- **No backend attack surface** — No database, API, or server-side session handling
- **localStorage limitation** — Data is stored client-side only; clearing browser data erases all requests; not suitable for real multi-user production use without a backend

---

## 🔭 Future Improvements

- [ ] Add a real backend and database (e.g. Amazon RDS / DynamoDB + REST API)
- [ ] Add user authentication (e.g. Amazon Cognito)
- [ ] Role-based access control (student vs. teacher vs. admin)
- [ ] Email notifications on request approval/denial (Amazon SES)
- [ ] Audit log for admin actions
- [ ] Terraform remote state via S3 + DynamoDB locking
- [ ] Multi-environment support (dev / staging / prod)

---

## 👤 Author

Built as a DevOps portfolio project demonstrating AWS infrastructure, containerisation, and CI/CD — hosting a lightweight frontend-only application on ECS Fargate.
