terraform {
  cloud {
    organization = "Terraform_space" # Replace with your HCP org
    workspaces {
      name = "AWS_deployment" # Replace with your workspace name
    }
  }
}