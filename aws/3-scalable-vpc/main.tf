###################
## VPC Resources
###################

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}
resource "aws_internet_gateway" "igw" {
  
}