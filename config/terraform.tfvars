region = "us-east-1"

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

vpc_name = "vpc01"
subnet_cidr_block = "10.0.0.0/18"

availability_zone = "us-east-1a"

tags = {
    "Name" = "public_us_east_1a"
}

}

"public_us_east_1b" = {
vpc_name = "vpc01"
subnet_cidr_block = "10.0.64.0/18"

availability_zone = "us-east-1b"

tags = {
    "Name" = "public_us_east_1b"
}
}

"private_us_east_1a" = {
vpc_name = "vpc01"
subnet_cidr_block = "10.0.128.0/18"

availability_zone = "us-east-1b"

tags = {
    "Name" = "private_us_east_1a"
}
    
}

"private_us_east_1b" = {
vpc_name = "vpc01"
subnet_cidr_block = "10.0.192.0/18"

availability_zone = "us-east-1b"

tags = {
    "Name" = "private_us_east_1b"
}
    
}

}

IGW_config = {
vpc_name = "vpc01"
vpc_id = ""

tags = {
    "Name" = "ACME-IGW"
}


}

rtb_config = {

publicrtb = {
vpc_name = "vpc01"
route_cidr_block = ""
tags = {
    "Name" = "public-rtb"
}

privatertb = {
vpc_name = "vpc01"
route_cidr_block = ""
tags = {
    "Name" = "private-rtb"
}
    }

}

rtb_assoc_config = {
subnet_d = ""
route_table_id = ""
}