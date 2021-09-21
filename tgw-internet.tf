resource "aws_ec2_transit_gateway" "TGW-Internet" {
  description                     = "TGW-Internet"
  default_route_table_propagation = "disable"
  default_route_table_association = "disable"

  tags = {
    Name = "TGW-Internet"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "Egress-Attachment" {
  subnet_ids                                      = [resource.aws_subnet.Egress-VPC_private_subnets[0].id, resource.aws_subnet.Egress-VPC_private_subnets[1].id]
  transit_gateway_id                              = aws_ec2_transit_gateway.TGW-Internet.id
  vpc_id                                          = resource.aws_vpc.vpc_name["Egress-VPC"].id
  transit_gateway_default_route_table_propagation = false
  transit_gateway_default_route_table_association = false

  tags = {
    Name = "Egress-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "App1-Attachment" {
  subnet_ids                                      = [resource.aws_subnet.App1-VPC_private_subnets[0].id, resource.aws_subnet.App1-VPC_private_subnets[1].id]
  transit_gateway_id                              = aws_ec2_transit_gateway.TGW-Internet.id
  vpc_id                                          = resource.aws_vpc.vpc_name["App1-VPC"].id
  transit_gateway_default_route_table_propagation = false
  transit_gateway_default_route_table_association = false

  tags = {
    Name = "App1-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "App2-Attachment" {
  subnet_ids                                      = [resource.aws_subnet.App2-VPC_private_subnets[0].id, resource.aws_subnet.App2-VPC_private_subnets[1].id]
  transit_gateway_id                              = aws_ec2_transit_gateway.TGW-Internet.id
  vpc_id                                          = resource.aws_vpc.vpc_name["App2-VPC"].id
  transit_gateway_default_route_table_propagation = false
  transit_gateway_default_route_table_association = false

  tags = {
    Name = "App2-Attachment"
  }
}


#Choose AWS Transit Gateway Route tables and create two route tables. Name the route tables Egress-RouteTable and App-RouteTable and associate both route tables with the TGW-Internet transit gateway.

resource "aws_ec2_transit_gateway_route_table" "Egress-RouteTable" {
  transit_gateway_id = aws_ec2_transit_gateway.TGW-Internet.id

  tags = {
    Name = "Egress-RouteTable"
  }
}

resource "aws_ec2_transit_gateway_route_table" "App-RouteTable" {
  transit_gateway_id = aws_ec2_transit_gateway.TGW-Internet.id

  tags = {
    Name = "App-RouteTable"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "App-RouteTable-App1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.App1-Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.App-RouteTable.id
}

resource "aws_ec2_transit_gateway_route_table_association" "App-RouteTable-App2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.App2-Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.App-RouteTable.id
}

#On the same route table, choose Routes, Create route, enter the 0.0.0.0/0 route, and choose the attachment: Egress-VPC.

resource "aws_ec2_transit_gateway_route" "default_App-RouteTable_Egress-VPC" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Egress-Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.App-RouteTable.id
}

#Add these additional routes: 192.168.0.0/16, 172.16.0.0/12 and 10.0.0.0/8 as Blackhole to make sure VPCs can’t communicate with each other through the NAT gateway.

resource "aws_ec2_transit_gateway_route" "blackhole_route" {
  count                          = length(var.blackhole_routes)
  destination_cidr_block         = var.blackhole_routes[count.index]
  blackhole                      = true
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.App-RouteTable.id
}

# Under AWS Transit Gateway route tables, choose Egress-RouteTable, Associations, Create association. Associate Egress-Attachment to this route table.

resource "aws_ec2_transit_gateway_route_table_association" "Egress-RouteTable-Egress" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Egress-Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Egress-RouteTable.id
}

# On the same route table, choose Routes, choose Create route, and enter 10.0.0.0/16 with the attachment App1-Attachment. Then enter a second route for 10.1.0.0/16 with the attachment App2-Attachment.

resource "aws_ec2_transit_gateway_route" "route_Egress-RouteTable_App1" {
  destination_cidr_block         = "10.0.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.App1-Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Egress-RouteTable.id
}

resource "aws_ec2_transit_gateway_route" "route_Egress-RouteTable_App2" {
  destination_cidr_block         = "10.1.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.App2-Attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.Egress-RouteTable.id
}

# In the left navigation pane, choose Route Tables and edit the default route table associated with App1-VPC and App2-VPC, adding a 0.0.0.0/0 route and set TGW-Internet as the target.

resource "aws_default_route_table" "default_route_table_App1-VPC" {
  default_route_table_id = aws_vpc.vpc_name["App1-VPC"].main_route_table_id

  tags = {
    Name = "App1-VPC-RT"
  }
}

resource "aws_route" "default_route_App1-VPC" {
  route_table_id         = aws_default_route_table.default_route_table_App1-VPC.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.TGW-Internet.id
}

resource "aws_default_route_table" "default_route_table_App2-VPC" {
  default_route_table_id = aws_vpc.vpc_name["App2-VPC"].main_route_table_id

  tags = {
    Name = "App2-VPC-RT"
  }
}

resource "aws_route" "default_route_App2-VPC" {
  route_table_id         = aws_default_route_table.default_route_table_App2-VPC.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.TGW-Internet.id
}

# Edit the Egress-Public-RT route table associated with the Egress-VPC and add 10.0.0.0/16 and 10.1.0.0/16. Set TGW-Internet as the target.

resource "aws_route" "ingress_route_Egress-VPC_App1-VPC" {
  route_table_id         = aws_route_table.Egress-Public-RT.id
  destination_cidr_block = var.vpc_cidr["App1-VPC"]
  transit_gateway_id     = aws_ec2_transit_gateway.TGW-Internet.id
}

resource "aws_route" "ingress_route_Egress-VPC_App2-VPC" {
  route_table_id         = aws_route_table.Egress-Public-RT.id
  destination_cidr_block = var.vpc_cidr["App2-VPC"]
  transit_gateway_id     = aws_ec2_transit_gateway.TGW-Internet.id
}