provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source    = "../../modules/vpc"
  vpc_cidr  = "10.0.0.0/16"
  vpc_name  = "dev-vpc"
}

module "subnet" {
  source              = "../../modules/subnet"
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  subnet_name         = "dev"
}

module "security_group" {
  source      = "../../modules/security_group"
  vpc_id      = module.vpc.vpc_id
  sg_name     = "dev-ec2"
  sg_description = "Security group for EC2 instance in dev environment"

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
      # New rule for Grafana (port 3000)
    {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # You can restrict this to specific IPs for security
    description = "Grafana access"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}

module "ec2_instance" {
  source            = "../../modules/ec2"
  region            = "us-east-1"
  instance_type     = "t2.micro"
  subnet_id         = module.subnet.public_subnet_ids[0]
  vpc_id            = module.vpc.vpc_id
  key_name          = "Bhavik-KeyPair"
  instance_name     = "grafana-server"
  environment       = "dev"
  security_group_id = module.security_group.security_group_id
  user_data = <<EOF
              #!/bin/bash
              # Update the system
              apt-get update -y

              # Install dependencies
              apt-get install -y software-properties-common

              # Add Grafana repository and GPG key
              add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
              apt-get install -y apt-transport-https
              curl https://packages.grafana.com/gpg.key | sudo apt-key add -

              # Install Grafana
              apt-get update -y
              apt-get install -y grafana

              # Start Grafana
              systemctl enable grafana-server
              systemctl start grafana-server

              # Open port 3000 for Grafana (use ufw if applicable on Ubuntu)
              ufw allow 3000/tcp
              ufw reload

              # Enable Grafana service on boot
              systemctl enable grafana-server
              EOF

}

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnet.private_subnet_ids
}

output "security_group_id" {
  value = module.security_group.security_group_id
}