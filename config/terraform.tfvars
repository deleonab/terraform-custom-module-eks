vpc_config = {

vpc01 = {

vpc_cidr_block = "10.0.0.0/16"

instance_tenancy = "default"

tags = {
 "Name" = "ACME-vpc"

}
}

}


subnet_config = {

"public_us_east_1a" = {


subnet_cidr_block = "10.0.1.0/18"

availability_zone = "us-east-1a"

tags = {
    "Name" = "public_us_east_1a"
}

}

"public_us_east_1b" = {

subnet_cidr_block = "10.0.101.0/18"

availability_zone = "us-east-1b"

tags = {
    "Name" = "public_us_east_1b"
}
}

"private_us_east_1a" = {
subnet_cidr_block = "10.0.151.0/18"

availability_zone = "us-east-1b"

tags = {
    "Name" = "private_us_east_1a"
}
    
}

"private_us_east_1b" = {
subnet_cidr_block = "10.0.201.0/18"

availability_zone = "us-east-1b"

tags = {
    "Name" = "private_us_east_1b"
}
    
}

}