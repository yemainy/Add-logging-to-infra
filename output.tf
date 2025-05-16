output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.yemi_logready_alb.dns_name
}

output "alb_https_url" {
  description = "HTTPS URL for the ALB"
  value       = "https://${aws_lb.yemi_logready_alb.dns_name}"
}

output "cloudwatch_log_group_name" {
  description = "The name of CloudWatch log groups for EC2 instances"
  value       = aws_cloudwatch_log_group.ec2_logs.name
}

output "cloudwatch_log_group_arn" {
  description = "The ARN of the CloudWatch log group used by EC2 instances for application logging."
  value       = aws_cloudwatch_log_group.ec2_logs.arn
}

output "alb_logs_bucket" {
  description = "The S3 bucket for ALB access logs"
  value       = aws_s3_bucket.alb_logs_bucket.bucket
}

output "alb_logs_bucket_arn" {
  description = "The ARN of the ALB access logs bucket"
  value       = aws_s3_bucket.alb_logs_bucket.arn
}

output "acm_cert_arn" {
  description = "ARN of the validated ACM certificate"
  value       = aws_acm_certificate_validation.cert_validation.certificate_arn
}

output "project_name" {
  description = "Project name for reference"
  value       = "yemi-logready"
}
