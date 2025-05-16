resource "aws_lb" "yemi_logready_alb" {
  name               = "yemi-logready-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id] # Reference the Security Group ID
  #subnets            = [aws_subnet.yemi-logready_public_az1a.id, aws_subnet.yemi-logready_public_az1b.id]
  
  # Subnet mappings for high availability across multiple Availability Zones
  subnet_mapping {
    subnet_id = aws_subnet.yemi-logready_public_az1a.id # public subnet in az1a
  }

  subnet_mapping {
    subnet_id = aws_subnet.yemi-logready_public_az1b.id # public subnet in az1b
  }

  # Enable deletion protection only for production environments (production-level infrastructure)
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.alb_logs_bucket.bucket
    enabled = true
    prefix  = "alb-logs"
  }

  tags = {
    Name        = "yemi-logready-alb"
    AppName     = "yemi-logready"
    Environment = "Production"
  }
}

resource "aws_lb_target_group" "yemi_tg" {
  name     = "yemi-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.yemi_logready_vpc.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "yemi-logready-tg"
    AppName     = "yemi-logready"
    Environment = "Production"
  }
}


# Listener for HTTP (port 80) with redirect action
# terraform aws create listener
# Use status code 301 (permanent redirect)
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.yemi_logready_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


# Listener for port 443 with forward action (HTTPS)
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.yemi_logready_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert_validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.yemi_tg.arn
  }
}


resource "aws_lb_target_group_attachment" "yemi_attach" {
  target_group_arn = aws_lb_target_group.yemi_tg.arn
  target_id        = aws_instance.yemi_ec2.id
  port             = 80
}
