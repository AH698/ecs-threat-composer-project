# Threat Composer on AWS ECS Fargate 

## Project overview

A production-style deployment of AWS Threat Composer, a threat modelling tool, running as a
container on Amazon ECS Fargate behind an Application Load Balancer and served over HTTPS 
on a custom domain.

The infrastructure is built with modular Terraform and managed through three GitHub Actions
pipelines: one to build and publish the container image, one to plan and apply 
infrastructure changes, and one to tear everything down on demand. The build and deploy 
pipelines includes security scanning. Authentication is processed via OIDC, which issues 
short-lived credentials for each run, so no long-lived access keys are ever stored 
in GitHub.

## Architecture diagram
![Architecture diagram](images/architecture-diagram.png)

## Repository structure 
```
.
├── .github
│   └── workflows
│       ├── destroy.yml
│       ├── image.yml
│       └── infra.yml
├── app/
├── bootstrap
│   ├── .terraform.lock.hcl
│   ├── main.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── images/
├── infra
│   ├── modules
│   │   ├── acm/
│   │   ├── alb/
│   │   ├── ecr/
│   │   ├── ecs/
│   │   ├── route53/
│   │   └── vpc/
│   ├── .terraform.lock.hcl
│   ├── main.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── .dockerignore
├── .gitignore
├── .pre-commit-config.yaml
├── .trivyignore
├── Dockerfile
└── README.md
```

## Tech Stack

![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)
![ECS Fargate](https://img.shields.io/badge/ECS_Fargate-232F3E)
![ALB](https://img.shields.io/badge/ALB-232F3E)
![ECR](https://img.shields.io/badge/ECR-232F3E)
![ACM](https://img.shields.io/badge/ACM-232F3E)
![Route 53](https://img.shields.io/badge/Route_53-232F3E)
![VPC](https://img.shields.io/badge/VPC-232F3E)
![CloudWatch](https://img.shields.io/badge/CloudWatch-232F3E)
![S3](https://img.shields.io/badge/S3-232F3E)
![IAM](https://img.shields.io/badge/IAM-232F3E)

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?logo=githubactions&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![nginx](https://img.shields.io/badge/nginx-009639?logo=nginx&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA)
![Hadolint](https://img.shields.io/badge/Hadolint-374151)
![TFLint](https://img.shields.io/badge/TFLint-374151)

## Local Setup

### Prerequisites

To deploy this project yourself, you'll need:

- An AWS account with MFA switched on for your IAM user
- AWS CLI, configured with credentials for that account
- Docker, to build and test the container image locally
- Terraform (version 1.16 or later), to provision the infrastructure
- A registered domain with a Route 53 hosted zone, which the app will be served from
- An S3 bucket to hold the Terraform remote state
- A GitHub OIDC setup in AWS: an identity provider for GitHub Actions and an IAM role whose trust policy only allows this repository

### Get the code

Clone this repository to your local machine:

```bash
git clone https://github.com/AH698/ecs-fargate-threat-composer-project.git
cd ecs-fargate-threat-composer-project
```

### Run the app locally

You can run the app on your own machine with Docker, without touching AWS.

1. Build the Docker image from the Dockerfile in the root of the repository:

```bash
   docker build -t threat-composer .
```

2. Start a container from the image:

```bash
   docker run --rm -p 8080:8080 threat-composer
```

3. Open http://localhost:8080 in your browser.

The container listens on port 8080 because it uses the non-root nginx image, and `-p 8080:8080` maps that port to your machine. Press Ctrl+C in the terminal to stop it.

### Deploy to AWS

1. In your GitHub repository settings, add the secrets `AWS_REGION`, `AWS_ROLE_ARN` and `AWS_ECR`, and create an environment called `production` with yourself as a required reviewer.
2. Update the trust policy of your IAM role so it matches your repository, including the `production` environment.
3. Update `infra/terraform.tfvars` with your domain, region and image tag.
4. Run the image workflow to build, scan and push the container image to ECR.
5. Push a change inside `infra/`, or run the infrastructure workflow manually. Review the plan, then approve the apply in Review deployments.
6. When you've finished, run the destroy workflow to tear everything down.

## How It Works

### Dockerfile 

The Dockerfile is the recipe for building the container image. Because the image contains everything the app needs,
it runs the same way on my machine, in the pipeline and in AWS, which solves the "it works on my machine" problem. 
It is a multi-stage build. The first stage compiles the app with Node, and the second stage copies only the built files into nginx-unprivileged. 
This keeps the final image small and free of build tools.The final image runs nginx as a non-root user, so a compromised container would not have 
root permissions. A non-root user cannot use ports below 1024, which is why the container listens on port 8080 instead of 80.

### Terraform remote backend

Terraform stores its state in an S3 bucket, with encryption turned on and lockfile locking enabled. 
This matters because the pipeline runners are thrown away after every run, so the state has to live somewhere shared for plan and apply to see the same infrastructure.
 Locking stops two runs from changing the state at the same time. The bucket itself is created outside Terraform, 
 because the code can't store its state in a bucket that doesn't exist yet.

### Terraform best practices

The infrastructure is split into modules for the VPC, ALB, ECR, ECS, ACM and Route 53, and the root module only wires them together using each 
module's outputs. This keeps the code DRY (Dont Repeat Yourself) values live in variables with defaults 
and in `terraform.tfvars`, and `count` builds the subnets in both availability zones from a single block instead of copying it. 
The root pins exact Terraform and provider versions, while each module only sets a minimum, so upgrades only need to be changed in one place. 
Formatting, validation and TFLint run in the pipeline, so problems are caught before anything is planned.

### Pipelines

There are three GitHub Actions pipelines. The image pipeline lints the Dockerfile with Hadolint, builds the image, 
scans it with Trivy, and only pushes it to ECR if both checks pass, tagged with the commit SHA. The infrastructure pipeline runs a Trivy scan, 
formatting, validation and TFLint before creating a plan, then pauses for manual approval on a protected production environment before applying. 
The destroy pipeline can only be started manually. All three authenticate to AWS with OIDC, so no access keys are stored in GitHub.

## App Demo

![Threat Composer running over HTTPS](images/live-app-https.png)

![Short demo of the live app](images/live-app-demo.gif)

## Pipeline Screenshots

### Image pipeline

![Image pipeline run](images/Docker-image-build:push-pipeline.png)

### Plan and apply pipeline

![Plan job](images/infra-fmt-plan-pipeline.png)

![Apply job](images/infra-apply-pipeline.png)

### Destroy pipeline

![Destroy pipeline run](images/Terraform-destroy-pipeline.png)
