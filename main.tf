terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a EC2 Instance
resource "aws_ami_copy" "firstserverinstance" {
  name              = "terraform-1"
  source_ami_id     = "ami-04b7f73ef0b798a0f"
  source_ami_region = "us-east-1"


  tags = {
    Name = "FirstServer"
  }
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
