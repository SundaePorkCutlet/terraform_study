terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }

  //테라폼 클라우드로 마이그레이션
  # backend "s3" {
  #   bucket = "junho-tf-backend-bucket"
  #   key    = "terraform.tfstate"
  #   region = "ap-northeast-2"
  # }

  cloud {
    hostname = "app.terraform.io"
    organization = "junho-terraform"

    workspaces {
      name = "fastcampus-prd"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "default_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "default-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2b"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets  = ["10.0.100.0/24", "10.0.101.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = {
    Terraform = "true"
    Environment = terraform.workspace
  }
}



# module "custom_vpc" {
#   source = "./custom_vpc"
#   env = "dev"
# }

# module "prd_custom_vpc" {
#   source = "./custom_vpc"
#   env = "prd"
# }

# variable "envs" {
#   type    = list(string)
#   default = ["dev", "prd", ""]
# }

//workspace를 사용하면 환경별로 구분할 수 있다.
//terraform 명령어는 왠만하면 root main에서만 사용하는게 좋다.
# module "main_vpc" {
#   source   = "./custom_vpc"
#   env      = terraform.workspace
# }

# resource "aws_s3_bucket" "tf_backend" {
#   count = terraform.workspace == "default" ? 1 : 0
#   bucket = "junho-tf-backend-bucket"
#   acl    = "private"

#   versioning {
#     enabled = true
#   }

#   tags = {
#     Name = "Terraform-bucket"
#   }
# }

//eip는 과금이 발생할 수 있으니 주의
# resource "aws_eip" "eip_temp"{
#   provisioner "local-exec" {
#     command = "echo ${aws_eip.eip_temp.public_ip} > eip.txt"
#   }

#   tags = {
#     Name = "temp"
#   }
#   }