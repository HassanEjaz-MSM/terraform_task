variable "aws_region" {}
variable "vpc_cidr" {}

variable "cidrs" {
  type = "map"

  default {
    public1  = "10.0.1.0/24"
    public2  = "10.0.2.0/24"
    private1 = "10.0.3.0/24"
    private2 = "10.0.4.0/24"
  }
}

//variable "key_name" {}

data "aws_availability_zones" "available" {}

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
