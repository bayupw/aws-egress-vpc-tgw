resource "aws_instance" "egress_ec2" {
  subnet_id                   = aws_subnet.Egress-VPC_private_subnets[0].id
  ami                         = var.linux2_ami
  instance_type               = var.instance_type
  key_name                    = var.keypair_name
  vpc_security_group_ids      = ["${aws_security_group.sg[count.index].id}"]
  associate_public_ip_address = true
}

resource "aws_instance" "app1_ec2" {
  subnet_id                   = aws_subnet.App1-VPC_private_subnets[0].id
  ami                         = var.linux2_ami
  instance_type               = var.instance_type
  key_name                    = var.keypair_name
  vpc_security_group_ids      = ["${aws_security_group.sg[count.index].id}"]
  associate_public_ip_address = false
}

resource "aws_instance" "app2_ec2" {
  subnet_id                   = aws_subnet.App2-VPC_private_subnets[1].id
  ami                         = var.linux2_ami
  instance_type               = var.instance_type
  key_name                    = var.keypair_name
  vpc_security_group_ids      = ["${aws_security_group.sg[count.index].id}"]
  associate_public_ip_address = false
}