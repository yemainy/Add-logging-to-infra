resource "aws_instance" "yemi_ec2" {
  ami                         = "ami-0e58b56aa4d64231b"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_app_subnet_az1a.id
  security_groups             = [aws_security_group.ec2_sg.id]
  key_name                    = "ableGod"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
     sudo su
     yum update -y
     yum install -y httpd
     cd /var/www/html
     wget https://github.com/Ahmednas211/jupiter-zip-file/raw/main/jupiter-main.zip
     unzip jupiter-main.zip
     cp -r jupiter-main/* /var/www/html
     rm -rf jupiter-main jupiter-main.zip
     systemctl start httpd
     systemctl enable httpd
   EOF

  tags = {
    Name        = "yemi-logready"
    Environment = "production"
  }
}