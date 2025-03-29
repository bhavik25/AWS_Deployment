variable "region" {
  description = "AWS region to deploy the EC2 instance"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (optional, defaults to latest Ubuntu 22.04)"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the instance"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group to attach to the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "user_data" {
  description = "Server configuration information"
  type        = string
}