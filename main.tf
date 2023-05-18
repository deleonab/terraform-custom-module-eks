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
  source = "./modules/aws_IGW"
  vpc_id = ""
  tags = ""
  
}