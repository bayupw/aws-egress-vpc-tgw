# 4 Create a NAT gateway in the VPC Egress-VPC.
/*
resource "aws_eip" "nat_gw_eip" {
  depends_on = [aws_internet_gateway.egress_igw]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id      = aws_subnet.Egress-VPC_public_subnets[0].id

  tags = {
    Name = "NAT Gateway"
  }

  depends_on = [aws_internet_gateway.egress_igw]
}

resource "aws_route_table" "Egress-Private-RT" {
  vpc_id = aws_vpc.vpc_name["Egress-VPC"].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = resource.aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Egress-Private-RT"
  }
  depends_on = [resource.aws_nat_gateway.nat_gw]
}

resource "aws_route_table_association" "Egress-Private-RT-assoc" {
  count          = length(var.Egress-VPC_private_subnets.subnet_names)
  subnet_id      = aws_subnet.Egress-VPC_private_subnets[count.index].id
  route_table_id = aws_route_table.Egress-Private-RT.id

    depends_on = [resource.aws_route_table.Egress-Private-RT]
}
*/