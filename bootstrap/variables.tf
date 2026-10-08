# s3 bucket 
variable "s3_bucket" {
  description = "s3 bucket name"
  type        = string
}

# ecr 
variable "ecr_name" {
  description = "name of the ecr repo"
  type        = string
}