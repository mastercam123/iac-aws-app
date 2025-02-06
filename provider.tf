terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket = "tf-state-hsn-test2013"
    key    = "atlantis-project/terraform.tfstate"
    region = "eu-central-1"
  }
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