module "aws_vpc_module" {
  source = "./modules/aws_vpc"

  for_each = var.vpc_config

  vpc_cidr_block = each.value.vpc_cidr_block

  instance_tenancy = each.value.instance_tenancy

  tags = each.value.tags

}

module "aws_subnet_module" {
  source = "./modules/aws_subnets"

  for_each = var.subnet_config

  subnet_cidr_block = each.value.subnet_cidr_block

  availability_zone = each.value.availability_zone

  vpc_id = module.aws_vpc_module[each.value.vpc_name].vpc_id

  tags = each.value.tags

}


module "IGW_module" {
  source   = "./modules/aws_IGW"
  for_each = var.IGW_config
  vpc_id   = module.aws_vpc_module[each.value.vpc_name].vpc_id
  tags     = each.value.tags

}

module "rtb_module" {
  source     = "./modules/aws_route_table"
  for_each   = var.rtb_config
  vpc_id     = module.aws_vpc_module[each.value.vpc_name].vpc_id
  gateway_id = each.value.private == 0 ? module.IGW_module[each.value.gateway_name].IGW_id : module.nat_gateway_module[each.value.gateway_name].nat_gateway_id
  tags       = each.value.tags

}



module "rtb_assoc_module" {
  source         = "./modules/aws_route_table_association"
  for_each       = var.rtb_assoc_config
  subnet_id      = module.aws_subnet_module[each.value.subnet_name].subnet_id
  route_table_id = module.rtb_module[each.value.route_table_name].rtb_id
}

module "nat_gateway_module" {
  source        = "./modules/aws_nat_gateway"
  for_each      = var.natgw_config
  subnet_id     = module.aws_subnet_module[each.value.subnet_name].subnet_id
  allocation_id = module.eip_module[each.value.eip_name].eip_id
  tags          = each.value.tags

}

module "eip_module" {
  source   = "./modules/aws_eip"
  for_each = var.eip_config
  tags     = each.value.tags
}

module "eks_module" {
  source = "./modules/aws_eks"
  for_each = var.eks_cluster_config
  cluster_name = each.value.cluster_name
  subnet_ids = ""
  tags= each.value.tags
}

module "nodegroups_module" {
  source = "./modules/aws_eks_nodegroups"
  for_each = var.nodegroup_config
  cluster_name = each.value.cluster_name

  subnet_ids = ""

  node_group_name = each.value.node_group_name

  tags = each.value.tags

}