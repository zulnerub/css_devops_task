terraform {
    required_version = ">=1.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            #version = "~> 3.12.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
    access_key = var.access_key
    secret_key = var.secret_key
}
