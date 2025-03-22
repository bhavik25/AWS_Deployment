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
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "FirstServer" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
 # key_name     = aws_key_pair.Bhavik_key.public_key
  key_name      = "Bhavik-KeyPair" 
  subnet_id     = aws_subnet.Terraform_Subnet.id
  
  tags = {
    Name = "FirstServer"
  }
}

#import {
#  to = aws_key_pair.Bhavik_key
#  id = "key-0190a5d7f96da12b5"
#


#Add SSH Key Pair
#resource "aws_key_pair" "Bhavik_key" {
#  key_name   = "Bhavik_key"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOBsn1ZV+lRPPwMcrcjBOKtGK2fw2rD/2FItPS43luBskxwtULjAJWcOAShn59aeiDTopqagVwdp8Y/k700cgcX6HAEKuAzjZULmJ2z5lnzAP05Nmf+FX+dddBRV+8H1NeDyNHoh2xntPKH/a8nAoZZIPrdjeqx2X6cSSKJ0Rr8khLRLj9uHh8/HzzIfJVkSHtLq9w18QevMLK0PtlDzQAufllOU+XoCgf0Bi/oTzQi3DET749bSVPsn8YkBISIAKIY27/dHgjB7I5V/y++/Kjx2T7DuHeTE0L3D6mtraGvijj1LRbM99Me5USvjIu+dgBrGmkSlvKJ3USs+B/zdcZ Bhavik-KeyPair"
#}



# Create a VPC
resource "aws_vpc" "Terraform_VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "created by terraform"
  }
}

# Create a AWS Subnet
resource "aws_subnet" "Terraform_Subnet" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.10.0/24"

  tags = {
    Name = "created by terraform"
  }
}