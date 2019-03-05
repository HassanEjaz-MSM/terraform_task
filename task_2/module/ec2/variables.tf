data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }
}

variable "load_balancer_name" {}

variable "target_group_name" {}

//variable "key_name" {}

variable "vpc_cidr" {}

variable "vpc_id" {}

variable "pub1_subnet" {}

variable "pub2_subnet" {}

variable "priv1_subnet" {}

variable "priv2_subnet" {}
