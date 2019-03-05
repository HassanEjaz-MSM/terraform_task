module "and_test_provider" {
  source     = "../module/provider"
  aws_region = "eu-west-2"
}

module "and_test_vpc" {
  source   = "../module/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "Test-VPC"
}

module "and_test_ec2" {
  source             = "../module/ec2"
  vpc_id             = "${module.and_test_vpc.vpc_id}"
  vpc_cidr           = "10.0.0.0/16"
  pub1_subnet        = "${module.and_test_vpc.public_subnets[0]}"
  pub2_subnet        = "${module.and_test_vpc.public_subnets[1]}"
  priv1_subnet       = "${module.and_test_vpc.private_subnets[0]}"
  priv2_subnet       = "${module.and_test_vpc.private_subnets[1]}"
  load_balancer_name = "testLB"
  target_group_name  = "testTG"

  //key_name = "And"
}
