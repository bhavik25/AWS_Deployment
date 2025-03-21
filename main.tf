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
resource "aws_ami_copy" "example" {
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

resource "aws_key_pair" "deployer" {
  key_name   = "Bhavik-KeyPair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOBsn1ZV+lRPPwMcrcjBOKtGK2fw2rD/2FItPS43luBskxwtULjAJWcOAShn59aeiDTopqagVwdp8Y/k700cgcX6HAEKuAzjZULmJ2z5lnzAP05Nmf+FX+dddBRV+8H1NeDyNHoh2xntPKH/a8nAoZZIPrdjeqx2X6cSSKJ0Rr8khLRLj9uHh8/HzzIfJVkSHtLq9w18QevMLK0PtlDzQAufllOU+XoCgf0Bi/oTzQi3DET749bSVPsn8YkBISIAKIY27/dHgjB7I5V/y++/Kjx2T7DuHeTE0L3D6mtraGvijj1LRbM99Me5USvjIu+dgBrGmkSlvKJ3USs+B/zdcZ Bhavik-KeyPair"
}
