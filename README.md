In this project , we shall be creating infrastructure and kubernetes EKS cluster in AWS using Terraform reusable modules.

![Terraform |Modules](./images/terraform-modules.jpg)


Code re-use is essential as the same code can be leveraged and used accross teams, projects, environments and teams. It also promotes consistency and standardisation and can be used to enforce best practices in your organisation. Other advantages are easier collaboration between teams.

We shall be creating 
1. A VPC
2 public subnets and 2 private subnets 
(I have used 2 private subnets instead of 4 to reduce costs. The lower tier should host the applications MySQL database)
The public subnet will host our Jenkin and SonaQube servers with our Java application in the private subnet.
|We shall also be using only 2 AZ's which is the minimum requirement for an EKS cluster.

3. An Internet Gateway for the Public subnet
4.  Two(2) NAT Gateways in the public subnets for each AZ.
5. We shall deloying an EKS cluster into the private subnets 
6. Cluster Role
7. Nodegroup Role

For this demo, we shall be storing our state flies locally but ideally, it should be stored remotely in an S3 bucket with Dynamo DB for state locking.

Our folder structure will be as follows:
Folder Structure

config 
    terraform.tfvars
modules
    aws_vpc
    aws_subnets
    aws_IGW
    aws_nat_gateway
    aws_eip
    aws_route_table
    aws_route_table_association
    aws_eks
    aws_eks_nodegroups

main.tf
providers.tf
versions.tf
variables.tf
README.md
.gitignore

Each module folder will contain 3 sub folders
- main.tf
- variables.tf
- output.tf

### Let's start by creating our  VPC ######### VPC ##########################################################
This will be created in aws_vpc/main.tf

### main.tf
```
resource "aws_vpc" "acme_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = var.tags
}
```
### variables.tf

```
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  default = "default"
}

variable "tags" {
  
}
```
### output.tf
```
output "vpc_id" {
  value = aws_vpc.acme_vpc.id
}
```

####  Let's create our SUBNETS ########################################################################################
This will be created in aws_subnets/main.tf

### main.tf
```
resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block
  availability_zone = var.availability_zone

  tags = var.tags
}

```

### variables.tf
```
variable "subnet_cidr_block" {
  default = "10.0.0.0/24"
}

variable "availability_zone" {

}
variable "tags" {

}
variable "vpc_id" {

}

```
### output.tf

```
output "subnet_id" {
  value = aws_subnet.acme_subnet.id
}

```


### Let's create our INTERNET GATEWAY resource ####################################################
This will be created in aws_IGW/main.tf

### main.tf

```
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = var.tags
}

```

### variables.tf

```
variable "tags" {

}
variable "vpc_id" {

}
```

### outputs.tf

```
output "IGW_id" {
  value = aws_internet_gateway.igw.id
}

```

## Let's create our NAT GATEWAY ##########################################################

To allow internet access from the private subnets
aws_nat_gateway/main.tf

### main.tf

```
resource "aws_nat_gateway" "ngw" {
  allocation_id = var.allocation_id
  subnet_id     = var.subnet_id

  tags = var.tags


}
```

### variables.tf
```
variable "allocation_id" {

}
variable "subnet_id" {

}
variable "tags" {

}
```
### outputs.tf

```
output "nat_gateway_id" {
  value = aws_nat_gateway.ngw.id
}
```

### Let's create the ELASTIC IP #########################################################
This is needed by the NAT Gateway

aws_eip/main.tf

### main.tf
```
resource "aws_eip" "natgw_eip" {

  tags = var.tags
}
```
### variables.tf
```
variable "tags" {

}

```
### outputs.tf

```
output "eip_id" {
  value = aws_eip.natgw_eip.id
}
```


### It's time to create the ROUTE TABLES ###################################################
aws_route_table/main.tf

### main.tf
```
resource "aws_route_table" "rtb" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.rtb_cidr_block
    gateway_id = var.gateway_id
  }

```

  tags = var.tags
}
### variables.tf
```
variable "vpc_id" {

}

variable "rtb_cidr_block" {
  default = "0.0.0.0/0"
}

variable "gateway_id" {

}

variable "tags" {

}
```

### outputs.tf
```
output "rtb_id" {
  value = aws_route_table.rtb.id
}
```
### ROUTE TABLE ASSOCIATIONS #######################################################
Associate the route tables with their subnets
aws_route_table_associations/main.tf

### main.tf
```
resource "aws_route_table_association" "a" {
  subnet_id      = var.subnet_id
  route_table_id = var.route_table_id
}
```
### variables.tf
```
variable "subnet_id" {

}

variable "route_table_id" {

}
```

### outputs.tf
```
output "rtb_assoc_id" {
  value = aws_route_table_association.a.id
}
```

### That is all we need for our base architecture
### The next step is to create our eks cluster and roles

aws_eks/main.tf

### main.tf
```
resource "aws_eks_cluster" "acme_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.acme_eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.ACME-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.ACME-AmazonEC2ContainerRegistryReadOnly,

  ]
  tags = var.tags
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "acme_eks_cluster" {
  name               = "acme-eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ACME-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.acme_eks_cluster.name
}


resource "aws_iam_role_policy_attachment" "ACME-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.acme_eks_cluster.name
}

```
### variables.tf
```
variable "cluster_name" {
  
}

variable "tags" {
  
}
variable "subnet_ids" {
  
}
```
### outputs.tf
```
output "eks_cluster_output_name" {
    value = aws_eks_cluster.acme_cluster.name
  
}
```