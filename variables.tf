variable "aws_region" {
    description = "AWS region us-east-1"
    type        = string
    default     = "us-east-1"
  
}

variable "aws_vpc" {
    description = "AWS cidr"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "AWS Key Pair name for SSH access"
  type        = string
  default     = "Bhavik-KeyPair" 
}