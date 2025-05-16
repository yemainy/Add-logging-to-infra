# Variable for the VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Variable for the public-subnet-az1a CIDR block
variable "public_subnet_az1a_cidr" {
  description = "CIDR block for the public-subnet-az1a"
  type        = string
  default     = "10.0.0.0/24"
}

# Variable for the public-subnet-az1b CIDR block
variable "public_subnet_az1b_cidr" {
  description = "CIDR block for the public-subnet-az1b"
  type        = string
  default     = "10.0.1.0/24"
}

# Variable for the private-app-subnet-az1a CIDR block
variable "private_app_subnet_az1a_cidr" {
  description = "CIDR block for the private-app-subnet-az1a"
  type        = string
  default     = "10.0.2.0/24"
}

# Variable for the private-app-subnet-az1b CIDR block
variable "private_app_subnet_az1b_cidr" {
  description = "CIDR block for the private-app-subnet-az1b"
  type        = string
  default     = "10.0.3.0/24"
}
