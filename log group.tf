# Create CloudWatch log groups for EC2 instances
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/yemi-logready/ec2-instance-logs" # or "/ec2/${yemi-logready}/logs"
  retention_in_days = 30                                 # Retain logs for 30 days

  tags = {
    Name        = "yemi-logready-ec2-logs"
    AppName     = "yemi-logready"
    Environment = "Production"
  }
}