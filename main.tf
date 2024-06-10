terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "custom_vpc" {
  source = "./custom_vpc"
  env = "dev"
}

module "prd_custom_vpc" {
  source = "./custom_vpc"
  env = "prd"
}

variable "names" {
  type = list(string)
  default = ["junho","leader"]
} 

module "personal_custom_vpc" {
  for_each = toset(var.names)
  source = "./custom_vpc"
  env = "personal_${each.value}"
}