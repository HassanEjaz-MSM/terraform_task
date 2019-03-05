module "and_dev_provider" {
  source     = "../module/provider"
  aws_region = "eu-west-1"
}

module "and_dev_vpc" {
  source   = "../module/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "Dev-VPC"
}

module "and_dev_ec2" {
  source             = "../module/ec2"
  vpc_id             = "${module.and_dev_vpc.vpc_id}"
  vpc_cidr           = "10.0.0.0/16"
  pub1_subnet        = "${module.and_dev_vpc.public_subnets[0]}"
  pub2_subnet        = "${module.and_dev_vpc.public_subnets[1]}"
  priv1_subnet       = "${module.and_dev_vpc.private_subnets[0]}"
  priv2_subnet       = "${module.and_dev_vpc.private_subnets[1]}"
  load_balancer_name = "prodLB"
  target_group_name  = "prodTG"
}
