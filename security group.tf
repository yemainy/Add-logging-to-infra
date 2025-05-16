# Create a Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "yemi-logready-alb-sg"
  description = "Security group for ALB to allow HTTP/HTTPS traffic"
  vpc_id      = aws_vpc.yemi_logready_vpc.id # Replace with your VPC ID if using an existing one

  # Allow HTTP traffic (port 80)
  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere (you can restrict this later)
  }

  # Allow HTTPS traffic (port 443)
  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means "all protocols"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "yemi-logready-alb-sg"
    AppName     = "yemi-logready"
    Environment = "Production"
  }
}

# Create a Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "yemi-logready-ec2-sg"
  description = "Security group for EC2 instances to allow SSH, HTTP, and HTTPS traffic"
  vpc_id      = aws_vpc.yemi_logready_vpc.id # Replace with your VPC ID if using an existing one

  # Allow SSH traffic (port 22) from trusted IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Replace with your trusted IP
  }

  # Allow HTTP traffic (port 80) from the ALB's Security Group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Reference the ALB's Security Group
  }

  # Allow HTTPS traffic (port 443) from the ALB's Security Group
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Reference the ALB's Security Group
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means "all protocols"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "yemi-logready-ec2-sg"
    AppName     = "yemi-logready"
    Environment = "Production"
  }
}