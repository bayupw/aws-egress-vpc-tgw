resource "aws_instance" "egress_ec2" {
  subnet_id                   = aws_subnet.Egress-VPC_public_subnets[0].id
  ami                         = var.linux2_ami
  instance_type               = var.instance_type
  key_name                    = var.keypair_name
  vpc_security_group_ids      = [resource.aws_security_group.sg_egress_ec2.id]
  associate_public_ip_address = true

  tags = {
    Name = "Bastion"
  }

}

resource "aws_instance" "app1_ec2" {
  subnet_id                   = aws_subnet.App1-VPC_private_subnets[0].id
  ami                         = var.linux2_ami
  instance_type               = var.instance_type
  key_name                    = var.keypair_name
  vpc_security_group_ids      = [resource.aws_security_group.sg_app1_ec2.id]
  associate_public_ip_address = false

  tags = {
    Name = "App1VM"
  }
}

resource "aws_instance" "app2_ec2" {
  subnet_id                   = aws_subnet.App2-VPC_private_subnets[1].id
  ami                         = var.linux2_ami
  instance_type               = var.instance_type
  key_name                    = var.keypair_name
  vpc_security_group_ids      = [resource.aws_security_group.sg_app2_ec2.id]
  associate_public_ip_address = false

  tags = {
    Name = "App2VM"
  }
}