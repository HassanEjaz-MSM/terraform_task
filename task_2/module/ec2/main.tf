#-----------Security Groups------------#

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Used for accessing the dev instances"
  vpc_id      = "${var.vpc_id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allowing everything to keep it relitively short
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------Public Security Group for ALB------------#

resource "aws_security_group" "pub_sg" {
  name        = "pub_sg"
  description = "Used for public and private instances for load balancer access"
  vpc_id      = "${var.vpc_id}"

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access everywhere"
  }
}

#----------Private Security Group------------#

resource "aws_security_group" "priv_sg" {
  name        = "priv_sg"
  description = "Used to access private instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access everywhere"
  }
}

#-------------Application Load Balancer--------------#

resource "aws_alb" "alb" {
  name                       = "${var.load_balancer_name}"
  security_groups            = ["${aws_security_group.pub_sg.id}"]
  load_balancer_type         = "application"
  subnets                    = ["${var.pub1_subnet}", "${var.pub2_subnet}"]
  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

#---------Target Group---------------#

resource "aws_alb_target_group" "and_digital_tg" {
  name     = "${var.target_group_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.and_digital_tg.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "alb_route_path" {
  listener_arn = "${aws_alb_listener.alb.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.and_digital_tg.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/static/*"]
  }

  lifecycle {
    ignore_changes = ["priority"]
  }
}

#------------Bastion Host----------------#
/*
resource "aws_instance" "bastion_server" {
 
    ami                         = "${data.aws_ami.amazon-linux.id}"
    associate_public_ip_address = true
    instance_type               = "t2.micro"
    key_name                    = "${var.key_name}"
    vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}", "${aws_security_group.pub_sg.id}"]
    subnet_id                   = "${var.pub1_subnet}"
    user_data = <<USER_DATA
      #!/bin/bash
      yum update
  USER_DATA

}
*/
#-----------AutoScaling Group------------#
resource "aws_autoscaling_group" "asg" {
  launch_configuration = "${aws_launch_configuration.alc.id}"
  availability_zones   = ["eu-west-2b", "eu-west-2a"]

  min_size = 2
  max_size = 5

  health_check_type   = "ELB"
  target_group_arns   = ["${aws_alb_target_group.and_digital_tg.arn}"]
  vpc_zone_identifier = ["${var.priv1_subnet}", "${var.priv2_subnet}", "${var.pub1_subnet}", "${var.pub2_subnet }"]

  tag {
    key                 = "Name"
    value               = "ASG-And-Digital"
    propagate_at_launch = true
  }
}

#-------------Launch Configuration------------#
resource "aws_launch_configuration" "alc" {
  image_id      = "${data.aws_ami.amazon-linux.id}"
  instance_type = "t2.micro"

  //key_name = "${var.key_name}"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.priv_sg.id}", "${aws_security_group.pub_sg.id}"]

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<USER_DATA
      #!/bin/bash
      yum update
      yum -y install nginx
      echo "<h1>Hello World</h1>" > /usr/share/nginx/html/index.html
      chkconfig nginx on
      service nginx start
  USER_DATA
}
