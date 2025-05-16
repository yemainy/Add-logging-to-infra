# Create an S3 bucket for ALB logs
resource "aws_s3_bucket" "alb_logs_bucket" {
  bucket = "yemi-logready-alb-logs-${random_id.suffix.hex}"
  # This will force empty the bucket when destroying
  force_destroy = true

  tags = {
    AppName     = "yemi-logready"
    Environment = "Production"
  }
}

#ensures your bucket name is unique so its wont fail 
resource "random_id" "suffix" {
  byte_length = 4
}


resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = aws_s3_bucket.alb_logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs_bucket.arn}/*"
      }
    ]
  })
}
