resource "aws_route_table" "rtb" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.route_cidr_block
    gateway_id = var.gateway_id
  }

  

  tags = var.tags
}