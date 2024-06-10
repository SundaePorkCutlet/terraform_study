terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }

  backend "s3" {
    bucket = "junho-tf-backend-bucket"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# module "custom_vpc" {
#   source = "./custom_vpc"
#   env = "dev"
# }

# module "prd_custom_vpc" {
#   source = "./custom_vpc"
#   env = "prd"
# }

variable "envs" {
  type = list(string)
  default = ["dev","prd",""]
} 

module "vpc_list" {
  for_each = toset([for env in var.envs : env if env != ""])
  source = "./custom_vpc"
  env = "${each.value}"
}

resource "aws_s3_bucket" "tf_backend" {
  bucket = "junho-tf-backend-bucket"
  acl    = "private"
  
  versioning {
    enabled = true
  }

  tags = {
    Name        = "Terraform-bucket"
  }
}