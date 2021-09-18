# Create VPC

resource "aws_vpc" "vpc_name" {
  for_each         = var.vpc_cidr
  cidr_block       = each.value
  instance_tenancy = "default"

  tags = {
    Name = "${each.key}"
  }
}


resource "aws_subnet" "Egress-VPC_public_subnets" {
  count             = length(var.Egress-VPC_public_subnets.subnet_names)
  vpc_id            = resource.aws_vpc.vpc_name["Egress-VPC"].id
  cidr_block        = var.Egress-VPC_public_subnets.subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.Egress-VPC_public_subnets.subnet_names[count.index]}"
  }
}

resource "aws_subnet" "Egress-VPC_private_subnets" {
  count             = length(var.Egress-VPC_private_subnets.subnet_names)
  vpc_id            = resource.aws_vpc.vpc_name["Egress-VPC"].id
  cidr_block        = var.Egress-VPC_private_subnets.subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.Egress-VPC_private_subnets.subnet_names[count.index]}"
  }
}

resource "aws_subnet" "App1-VPC_private_subnets" {
  count             = length(var.App1-VPC_private_subnets.subnet_names)
  vpc_id            = resource.aws_vpc.vpc_name["App1-VPC"].id
  cidr_block        = var.App1-VPC_private_subnets.subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.App1-VPC_private_subnets.subnet_names[count.index]}"
  }
}

resource "aws_subnet" "App2-VPC_private_subnets" {
  count             = length(var.App2-VPC_private_subnets.subnet_names)
  vpc_id            = resource.aws_vpc.vpc_name["App2-VPC"].id
  cidr_block        = var.App2-VPC_private_subnets.subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.App2-VPC_private_subnets.subnet_names[count.index]}"
  }
}