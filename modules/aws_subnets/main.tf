resource "aws_subnet" "acme_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = var.tags
}

