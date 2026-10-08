output "alb_dns" {
  description = "alb dns, used in route53"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "alb zone id, used in route53"
  value       = aws_lb.alb.zone_id
}

output "alb_tg_arn" {
  description = "alb target group arn, used in ecs"
  value       = aws_lb_target_group.ip-tg.arn
}

output "alb_sg_id" {
  description = "alb security gorup id, used in ecs"
  value       = aws_security_group.sg_alb.id
}

