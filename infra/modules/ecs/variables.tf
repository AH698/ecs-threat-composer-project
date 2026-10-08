variable "cluster_name" {
  description = "name of the cluster"
  type        = string
}

variable "ecs_iam_execution_name" {
  description = "name of the ecs task execution iam role"
  type        = string
}

variable "iam_role_effect" {
  description = "either permits or denies action"
  type        = string
  default     = "Allow"
}


variable "vpc_id" {
  description = "the vpc id"
  type        = string
}

variable "ecs_sg_name" {
  description = "name of the ecs security group"
  type        = string
}

variable "alb_sg_id" {
  description = "id of the alb security group"
  type        = string
}

variable "container_port" {
  description = "ports that are able to communicate with ecs"
  type        = number
  default     = 8080
}

variable "ecs_sg_ingress_protocol" {
  description = "transport layer"
  type        = string
  default     = "tcp"
}

variable "ecs_sg_egress" {
  description = "outbound traffic"
  type        = number
  default     = 0
}

variable "ecs_sg_egress_protocol" {
  description = "protocols allowed"
  type        = string
  default     = "-1"
}

variable "cidr_blocks_egress" {
  description = "determines which ip add traffic can go to"
  type        = list(string)
  default     = ["0.0.0.0/0"]
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

variable "container_image" {
  description = "image which is in ecr"
  type        = string
}

variable "container_essential" {
  description = "value"
  type        = bool
  default     = true
}

variable "operating_system_family" {
  description = "operating system family of the image"
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "cpu architecture of the image"
  type        = string
}

variable "service_name" {
  description = "the name of the ecs service"
  type        = string
}

variable "service_desired_count" {
  description = "number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "alb_tg" {
  description = "refer to the alb tg in the root"
  type        = string
}

variable "priv_subnets_id" {
  description = "ids of the priv subnets the tasks run in"
  type        = list(string)
}


variable "ecs_assign_public_ip" {
  description = "auto assign public ip for ecs"
  type        = bool
  default     = false
}

variable "log_group_name" {
  description = "name of the log group"
  type        = string
  default     = "threat-composer"
}

variable "log_retention_days" {
  description = "log retention in days"
  type        = number
  default     = 7
}

variable "log_stream_prefix" {
  description = "start of the name of each log"
  type        = string
  default     = "ecs"
}