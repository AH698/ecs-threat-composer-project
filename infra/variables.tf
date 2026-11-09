# ecr module 
variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
}

# vpc module 
variable "vpc_name" {
  description = "name of the vpc"
  type        = string

}

variable "cidr_block_vpc" {
  description = "cidr_block"
  type        = string
}

variable "public_cidr" {
  description = "public subnets cidr block"
  type        = list(string)
}

variable "private_cidr" {
  description = "private subnets cidr block"
  type        = list(string)
}

# acm module 
variable "domain_name" {
  description = "domain name for app"
  type        = string
}

variable "r53_zone_name" {
  description = "The name of the r53 zone"
  type        = string
}

# alb module 
variable "alb_name" {
  description = "the name of the alb"
  type        = string
}

variable "sg_alb" {
  description = "name of the security group"
  type        = string
}

variable "alb_listener_2_status_code" {
  description = "status code for the redirect"
  type        = string
}

variable "tg_name" {
  description = "name of the tg"
  type        = string
}

variable "hc_tg_path" {
  description = "path for health check"
  type        = string
}

# ecs module 
variable "cluster_name" {
  description = "name of the cluster"
  type        = string
}

variable "ecs_iam_execution_name" {
  description = "name of the ecs task execution iam role"
  type        = string
}

variable "ecs_sg_name" {
  description = "name of the ecs security group"
  type        = string
}

variable "ecs_family" {
  description = "name of task definition grouping all numbered revisions together"
  type        = string
}

variable "ecs_task_def_cpu" {
  description = "cpu units available to the task"
  type        = number
}

variable "ecs_task_def_memory" {
  description = "memory in mib available to the task"
  type        = number
}

variable "container_name" {
  description = "name of the container"
  type        = string
}

variable "cpu_architecture" {
  description = "cpu architecture of the image"
  type        = string
}

variable "service_name" {
  description = "the name of the ecs service"
  type        = string
}

# route 53 module 
variable "type" {
  description = "dns_type"
  type        = string
}

# image tag
variable "image_tag" {
  description = "commit sha of the image to deploy"
  type        = string
}