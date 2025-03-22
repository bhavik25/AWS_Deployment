# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "Terraform_VPC" {
  cidr_block = var.aws_vpc

  tags = {
    Name = "created by terraform"
  }
}


# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Terraform_VPC.id

  tags = {
    Name = "Terraform IGW"
  }
}

# Create a Public Subnet
resource "aws_subnet" "Terraform_Subnet_public" {
  vpc_id                  = aws_vpc.Terraform_VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true  # Enables public IP assignment

  tags = {
    Name = "Terraform-PublicSubnet"
  }
}

# Create a Route Table for Public Subnet
resource "aws_route_table" "terraform_public_rt" {
  vpc_id = aws_vpc.Terraform_VPC.id

  tags = {
    Name = "Terraform-PublicRouteTable"
  }
}

# Create a Route to Allow Internet Access
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.terraform_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.Terraform_Subnet_public.id
  route_table_id = aws_route_table.terraform_public_rt.id
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
 #key_name      = aws_key_pair.Bhavik_key.public_key
  key_name      = "Bhavik-KeyPair" 
  subnet_id     = aws_subnet.Terraform_Subnet_public.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]  # Attach Security Group
  
  
  tags = {
    Name = "FirstServer"
  }
}


# Security Group to allow SSH access
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.Terraform_VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere (use a specific IP for better security)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow SSH"
  }
}

