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

    vpc_name          = "vpc01"
    subnet_cidr_block = "10.0.0.0/18"

    availability_zone = "us-east-1a"

    tags = {
      "Name" = "public_us_east_1a"
    }

  }

  "public_us_east_1b" = {
    vpc_name          = "vpc01"
    subnet_cidr_block = "10.0.64.0/18"

    availability_zone = "us-east-1b"

    tags = {
      "Name" = "public_us_east_1b"
    }
  }

  "private_us_east_1a" = {
    vpc_name          = "vpc01"
    subnet_cidr_block = "10.0.128.0/18"

    availability_zone = "us-east-1b"

    tags = {
      "Name" = "private_us_east_1a"
    }

  }

  "private_us_east_1b" = {
    vpc_name          = "vpc01"
    subnet_cidr_block = "10.0.192.0/18"

    availability_zone = "us-east-1b"

    tags = {
      "Name" = "private_us_east_1b"
    }

  }

}





IGW_config = {
  igw01 = {
    vpc_name = "vpc01"

    tags = {
      "Name" = "ACME-IGW"
    }
  }
}

rtb_config = {

  publicrtb01 = {
    private      = 0
    vpc_name     = "vpc01"
    gateway_name = "igw01"
    tags = {
      "Name" = "public-rtb1"
    }
  }
  privatertb01 = {
    private      = 1
    vpc_name     = "vpc01"
    gateway_name = "natgw01"
    tags = {
      "Name" = "private-rtb1"
    }
  }
  privatertb02 = {
    private      = 1
    vpc_name     = "vpc01"
    gateway_name = "natgw02"
    tags = {
      "Name" = "private-rtb2"
    }
  }

}

rtb_assoc_config = {
  public_rtb_assoc01 = {
    subnet_name      = "public_us_east_1a"
    route_table_name = "publicrtb01"
  }

  public_rtb_assoc02 = {
    subnet_name      = "public_us_east_1b"
    route_table_name = "publicrtb01"
  }

  private_rtb_assoc01 = {
    subnet_name      = "private_us_east_1a"
    route_table_name = "privatertb01"
  }

  private_rtb_assoc02 = {
    subnet_name      = "private_us_east_1b"
    route_table_name = "privatertb02"
  }
}


natgw_config = {
  natgw01 = {
    eip_name    = "eip01"
    subnet_name = "public_us_east_1a"
    tags = {
      "Name" = "natgw01"
    }
    depends_on = ""

  }
  natgw02 = {
    eip_name    = "eip02"
    subnet_name = "public_us_east_1b"
    tags = {
      "Name" = "natgw02"

    }
    depends_on = ""

  }
}


eip_config = {

  eip01 = {


    tags = {
      "Name" = "elasticIP01"
    }
  }
  eip02 = {

    tags = {
      "Name" = "elasticIP02"

    }

  }

}


eks_cluster_config = {

cluster-key = {
cluster_name = "cluster-key"

subnet1 = "public_us_east_1a"
subnet2 = "public_us_east_1b"
subnet3 = "private_us_east_1a"
subnet4 = "private_us_east_1b"


tags = {

    "Name" = "ACME-cluster"
}
}

}


nodegroup_config = {

node1 = {
node_group_name = "node1"

cluster_name = "cluster-key"

node_i_am_role = "eks-node-role1"

subnet1 ="private_us_east_1a"
subnet2 ="private_us_east_1b"

tags = {

    "Name" = "ACME-clusterNode1"
}

}
node2 = {
node_group_name = "node2"

cluster_name = "cluster-key"

node_i_am_role = "eks-node-role1"


subnet1 ="private_us_east_1a"
subnet2 ="private_us_east_1b"

tags = {

    "Name" = "ACME-clusterNode2"
}

}


}