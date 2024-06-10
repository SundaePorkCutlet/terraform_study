resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc_${var.env}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.0.0/24"
  availability_zone = local.az_a

  tags = {
    Name = "terraform-public-subnet_1_${var.env}"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.10.0/24"
  //nat게이트웨이는 왠만하면 같게 사용하는게 좋다.
  availability_zone = local.az_a

  tags = {
    Name = "terraform-private-subnet_1_${var.env}"
  }
}
//비싸요
# resource "aws_nat_gateway" "private_nat" {
#   connectivity_type = "private"
#   subnet_id         = aws_subnet.private_subnet_1.id

#     tags = {
#         Name = "terraform-nat_${var.env}"
#     } 
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.default.id

#     tags = {
#         Name = "terraform-igw_${var.env}"
#     }
# }