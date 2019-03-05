output "vpc_id" {
  value = "${aws_vpc.and_digital.id}"
}

output "private_subnets" {
  value = ["${aws_subnet.and_digital_priv1_subnet.id}", "${aws_subnet.and_digital_priv2_subnet.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.and_digital_pub1_subnet.id}", "${aws_subnet.and_digital_pub2_subnet.id}"]
}

output "igw_id" {
  value = "${aws_internet_gateway.and_digital_gateway.id}"
}

output "private_route_table_ids	" {
  value = ["${aws_default_route_table.and_digital_priv_rt.id}"]
}

output "public_route_table_ids" {
  value = ["${aws_route_table.and_digital_public_rt.id}"]
}
