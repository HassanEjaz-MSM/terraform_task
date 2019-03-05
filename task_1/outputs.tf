#Will output the load balancer name to visit the hello world page.
output "elb_dns_name" {
  value = "${aws_alb.alb.dns_name}"
}
