variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable "availability_zones" {
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "vpc_cidr" {
  default = {
    "Egress-VPC" = "192.168.0.0/16"
    "App1-VPC"   = "10.0.0.0/16"
    "App2-VPC"   = "10.1.0.0/16"
  }
}

variable "blackhole_routes" {
  default = [
# 192.168.0.0/16 is removed from blackhole routs for testing purpose
#   "192.168.0.0/16",
    "172.16.0.0/12",
    "10.0.0.0/8"
  ]
}

variable "Egress-VPC_public_subnets" {
  default = {
    "subnet_names" = ["Egress-Public-AZ1", "Egress-Public-AZ2"]
    "subnets"      = ["192.168.1.0/24", "192.168.2.0/24"]
  }
}

variable "Egress-VPC_private_subnets" {
  default = {
    "subnet_names" = ["Egress-Private-AZ1", "Egress-Private-AZ2"]
    "subnets"      = ["192.168.3.0/24", "192.168.4.0/24"]
  }
}

variable "App1-VPC_private_subnets" {
  default = {
    "subnet_names" = ["App1-Private-AZ1", "App1-Private-AZ2"]
    "subnets"      = ["10.0.1.0/24", "10.0.2.0/24"]
  }
}

variable "App2-VPC_private_subnets" {
  default = {
    "subnet_names" = ["App2-Private-AZ1", "App2-Private-AZ2"]
    "subnets"      = ["10.1.1.0/24", "10.1.2.0/24"]
  }
}

variable "keypair_name" {}

variable "my_public_ip" {}

variable "linux2_ami" {
  description = "Amazon Linux 2 AMI (HVM) AMI ID"
  default = "ami-087c17d1fe0178315"
}

variable "instance_type" {
  default = "t2.micro"
}