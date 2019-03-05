variable "vpc_cidr" {}
variable "vpc_name" {}

data "aws_availability_zones" "available" {}

variable "cidrs" {
  type = "map"

  default {
    public1  = "10.0.1.0/24"
    public2  = "10.0.2.0/24"
    private1 = "10.0.3.0/24"
    private2 = "10.0.4.0/24"
  }
}
