terraform {
  required_version = ">=1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      managed_by = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "central_backup"
  region = var.aws_region
  assume_role {
    role_arn = var.management_role
  }
  default_tags {
    tags = {
      managed_by = "Terraform-main-account"
    }
  }
}