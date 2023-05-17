We shall be creating 
1. A VPC
2 public subnets and 4 private subnets
3. An Internet Gateway for the Public subnet
4.  Two(2) NAT Gateways for each AZ for the private subnet
5. We shall deloying an EKS cluster into the private subnets 
6. Cluster Role
7. Nodegroup Role


Folder Structure

config 
    terraform.tfvars
modules
    aws_vpc
    aws_subnets

main.tf
providers.tf
versions.tf
variables.tf

### VPC ######### VPC ######################

# main.tf
```
resource "aws_vpc" "acme_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = var.tags
}
```
# variables.tf

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


#####  SUBNETS ###########

# main.tf
```
resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block
  availability_zone = var.availability_zone

  tags = var.tags
}

```

# variables.tf
```
variable "subnet_cidr_block" {
  default = "10.0.0.0/24"
}

variable "availability_zone" {
  
}
variable "tags" {
  
}

variable "vpc_id"{

}

```