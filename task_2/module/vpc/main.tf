#-------------VPC----------------#
resource "aws_vpc" "and_digital" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${var.vpc_name}"
  }
}

#----------------Internet Gateway----------------#

resource "aws_internet_gateway" "and_digital_gateway" {
  vpc_id = "${aws_vpc.and_digital.id}"

  tags {
    Name = "and_digital_gateway"
  }
}

#-----------------------Subnets---------------------#

resource "aws_subnet" "and_digital_pub1_subnet" {
  vpc_id                  = "${aws_vpc.and_digital.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "and_digital_public1"
  }
}

resource "aws_subnet" "and_digital_pub2_subnet" {
  vpc_id                  = "${aws_vpc.and_digital.id}"
  cidr_block              = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "and_digital_public2"
  }
}

resource "aws_subnet" "and_digital_priv1_subnet" {
  vpc_id                  = "${aws_vpc.and_digital.id}"
  cidr_block              = "${var.cidrs["private1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "and_digital_private1"
  }
}

resource "aws_subnet" "and_digital_priv2_subnet" {
  vpc_id                  = "${aws_vpc.and_digital.id}"
  cidr_block              = "${var.cidrs["private2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "and_digital_private2"
  }
}

#-------------------Route Tables--------------------#

resource "aws_route_table" "and_digital_public_rt" {
  vpc_id = "${aws_vpc.and_digital.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.and_digital_gateway.id}"
  }

  tags {
    Name = "and_digital_public_rt"
  }
}

resource "aws_default_route_table" "and_digital_priv_rt" {
  default_route_table_id = "${aws_vpc.and_digital.default_route_table_id}"

  tags {
    Name = "and_digital_priv_rt"
  }
}

#--------------------Subnet Associations------------------------#

resource "aws_route_table_association" "and_digital_pub1_assoc" {
  subnet_id      = "${aws_subnet.and_digital_pub1_subnet.id}"
  route_table_id = "${aws_route_table.and_digital_public_rt.id}"
}

resource "aws_route_table_association" "and_digital_pub2_assoc" {
  subnet_id      = "${aws_subnet.and_digital_pub2_subnet.id}"
  route_table_id = "${aws_route_table.and_digital_public_rt.id}"
}

resource "aws_route_table_association" "and_digital_priv1_assoc" {
  subnet_id      = "${aws_subnet.and_digital_priv1_subnet.id}"
  route_table_id = "${aws_default_route_table.and_digital_priv_rt.id}"
}

resource "aws_route_table_association" "and_digital_priv2_assoc" {
  subnet_id      = "${aws_subnet.and_digital_priv2_subnet.id}"
  route_table_id = "${aws_default_route_table.and_digital_priv_rt.id}"
}
