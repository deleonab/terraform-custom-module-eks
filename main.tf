module "aws_vpc" {
  source = "./modules/aws_vpc"
}

module "aws_subnet" {
  source = "./modules/aws_subnets"
}