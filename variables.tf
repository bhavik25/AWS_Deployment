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