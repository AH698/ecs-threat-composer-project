output "r53_zone_id" {
  description = "the route53 zone id, used in route53"
  value       = data.aws_route53_zone.r53_zone.zone_id
}

output "acm_cert" {
  description = "the acm certificate, used in alb"
  value       = aws_acm_certificate_validation.cert_valid.certificate_arn
}