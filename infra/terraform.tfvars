# ecr module
ecr_name = "threat-composer"

# vpc module 
vpc_name       = "threat-composer-vpc"
cidr_block_vpc = "10.0.0.0/16"
public_cidr    = ["10.0.1.0/24", "10.0.2.0/24"]
private_cidr   = ["10.0.3.0/24", "10.0.4.0/24"]

# acm module
domain_name   = "tm.aryhuss.co.uk"
r53_zone_name = "aryhuss.co.uk"

# alb module 
alb_name                   = "threat-composer-alb"
sg_alb                     = "threat-composer-alb-sg"
alb_listener_2_status_code = "HTTP_301"
tg_name                    = "threat-composer-tg"
hc_tg_path                 = "/health"

# ecs module 
cluster_name           = "threat-composer-cluster"
ecs_iam_execution_name = "threat-composer-IAM-execution"
ecs_sg_name            = "threat-composer-ecs-sg"
ecs_family             = "threat-composer-task"
ecs_task_def_cpu       = 256
ecs_task_def_memory    = 512
service_name           = "threat-composer-service"
container_name         = "threat-composer-container"
cpu_architecture       = "X86_64"

# route 53 module 
type = "A"

# image tag
image_tag = "de74c6a8b6ba5dd9f41e690406f40918689ec079"