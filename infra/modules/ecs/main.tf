resource "aws_ecs_cluster" "ecs_threat_composer" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_task_execution_iam" {
  name = var.ecs_iam_execution_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = var.iam_role_effect
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_policy" {
  role       = aws_iam_role.ecs_task_execution_iam.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs_sg" {
  name   = var.ecs_sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = var.ecs_sg_ingress_protocol
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = var.ecs_sg_egress
    to_port     = var.ecs_sg_egress
    protocol    = var.ecs_sg_egress_protocol
    cidr_blocks = var.cidr_blocks_egress
  }
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_days
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = var.ecs_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_def_cpu
  memory                   = var.ecs_task_def_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_iam.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = var.container_essential
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = data.aws_region.current.region
          "awslogs-stream-prefix" = var.log_stream_prefix
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecs_threat_composer.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count   = var.service_desired_count
  depends_on      = [aws_iam_role_policy_attachment.iam_policy]
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.alb_tg
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.priv_subnets_id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = var.ecs_assign_public_ip
  }
}