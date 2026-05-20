# 🏫 School Equipment Borrowing System

> A production-grade, AWS-deployed web application for managing school equipment borrowing requests — built with PHP, containerised with Docker, and orchestrated on ECS Fargate via Terraform and GitHub Actions.

---

## 📌 Overview

The **School Equipment Borrowing System** is a full-stack web application that streamlines how students and teachers request school equipment. An admin dashboard allows authorised users to approve or deny requests and set return dates.

While the frontend uses browser `localStorage` for lightweight persistence, the surrounding infrastructure is fully production-grade — deployed on **AWS ECS Fargate** behind an **Application Load Balancer** with **HTTPS termination**, automated CI/CD, and infrastructure-as-code via **Terraform**.

---

## 🏗️ Architecture

```
User
 └──▶ Route 53 (DNS)
        └──▶ ALB (HTTPS via ACM)
               └──▶ ECS Fargate (Apache + PHP container)
                          │
                          └──▶ Amazon ECR (Docker image registry)

Infrastructure provisioned with Terraform (modular)
CI/CD via GitHub Actions + AWS OIDC (keyless auth)
Region: eu-north-1
```

### AWS Services Used

| Service | Role |
|---|---|
| **ECS Fargate** | Serverless container hosting |
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
- 💾 **localStorage Persistence** — Client-side data storage (no backend database required)

---

## 🧰 Tech Stack

### Frontend
- PHP 8
- HTML5 / CSS3
- Vanilla JavaScript

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
│   ├── provider.tf             # AWS provider + backend
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Stack outputs
│   └── modules/
│       ├── vpc/                # VPC, subnets, routing
│       ├── ecr/                # ECR repository
│       ├── alb/                # Load balancer + HTTPS listener
│       ├── ecs/                # Fargate cluster, task def, service
│       └── route53/            # DNS records
│
├── school-equipment/
│   ├── Dockerfile              # Apache + PHP image
│   ├── index.php               # Student/teacher borrowing form
│   ├── admin.php               # Admin dashboard
│   └── assets/
│       ├── css/style.css       # Global styles
│       └── js/
│           ├── app.js          # Request submission logic
│           ├── admin.js        # Admin dashboard logic
│           └── storage.js      # localStorage abstraction layer
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
git clone https://github.com/<your-org>/ECS-project-NewApp.git
cd ECS-project-NewApp/school-equipment

# Build the Docker image
docker build -t school-equipment .

# Run the container
docker run -p 8080:80 school-equipment
```

Open your browser at **http://localhost:8080**

> Admin panel is accessible at **http://localhost:8080/admin.php**

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
              └── 6. HTTPS health check (smoke test)
```

### Manual Infrastructure Deployment

```bash
cd Infra/

# Initialise Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

> Alternatively, trigger the `ecs-destroy.yml` workflow from GitHub Actions.

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `AWS_ACCOUNT_ID` | Target AWS account ID |
| `AWS_REGION` | Deployment region (`eu-north-1`) |
| `ECR_REPOSITORY` | ECR repo name |
| `ECS_CLUSTER` | ECS cluster name |
| `ECS_SERVICE` | ECS service name |

---

## 📸 Screenshots

> _Screenshots to be added after deployment._

| View | Preview |
|---|---|
| Borrowing Request Form | `screenshots/request-form.png` |
| Admin Dashboard | `screenshots/admin-dashboard.png` |
| Approve / Deny Flow | `screenshots/approval-flow.png` |
| Mobile View | `screenshots/mobile-view.png` |

---

## 🔒 Security Notes

- **No static AWS credentials** — GitHub Actions authenticates via AWS OIDC (IAM Identity Provider)
- **HTTPS enforced** — All traffic routed through ALB with ACM-managed TLS certificate
- **No public EC2 instances** — Fargate tasks run in private subnets; only ALB is internet-facing
- **ECR image scanning** — Enable on push via ECR configuration (recommended)
- **localStorage limitation** — Data is stored client-side only; not suitable for multi-user production use without a backend database

---

## 🔭 Future Improvements

- [ ] Replace `localStorage` with a backend database (e.g. Amazon RDS / DynamoDB)
- [ ] Add user authentication (e.g. Amazon Cognito)
- [ ] Role-based access control (student vs. teacher vs. admin)
- [ ] Email notifications on request approval/denial (Amazon SES)
- [ ] Audit log for admin actions
- [ ] Terraform remote state via S3 + DynamoDB locking
- [ ] Multi-environment support (dev / staging / prod)
- [ ] Automated integration tests in CI pipeline

---

## 👤 Author

Built as a DevOps portfolio project demonstrating end-to-end AWS infrastructure, containerisation, and CI/CD automation.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).