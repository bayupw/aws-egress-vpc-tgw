
resource "aws_security_group" "sg_egress_ec2" {
  name   = "sg_egress_ec2"
  vpc_id = resource.aws_vpc.vpc_name["Egress-VPC"].id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_app1_ec2" {
  name   = "sg_app1_ec2"
  vpc_id = resource.aws_vpc.vpc_name["App1-VPC"].id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr["Egress-VPC"]}", "${var.vpc_cidr["App1-VPC"]}", "${var.vpc_cidr["App2-VPC"]}"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr["Egress-VPC"]}", "${var.vpc_cidr["App1-VPC"]}", "${var.vpc_cidr["App2-VPC"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "sg_app2_ec2" {
  name   = "sg_app2_ec2"
  vpc_id = resource.aws_vpc.vpc_name["App2-VPC"].id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr["Egress-VPC"]}", "${var.vpc_cidr["App1-VPC"]}", "${var.vpc_cidr["App2-VPC"]}"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr["Egress-VPC"]}", "${var.vpc_cidr["App1-VPC"]}", "${var.vpc_cidr["App2-VPC"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}