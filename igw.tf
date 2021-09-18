# 5 Create two new route tables in Egress-VPC. For Name tags, use Egress-Public-RT and Egress-Private-RT.

resource "aws_internet_gateway" "egress_igw" {
  vpc_id = resource.aws_vpc.vpc_name["Egress-VPC"].id

  tags = {
    Name = "IGW"
  }
}
resource "aws_route_table" "Egress-Public-RT" {
  vpc_id = aws_vpc.vpc_name["Egress-VPC"].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = resource.aws_internet_gateway.egress_igw.id
  }

  tags = {
    Name = "Egress-Public-RT"
  }
  depends_on = [resource.aws_internet_gateway.egress_igw]
}

resource "aws_route_table_association" "Egress-Public-RT-assoc" {
  count          = length(var.Egress-VPC_public_subnets.subnet_names)
  subnet_id      = aws_subnet.Egress-VPC_public_subnets[count.index].id
  route_table_id = aws_route_table.Egress-Public-RT.id

  depends_on = [resource.aws_route_table.Egress-Public-RT]
}