output "vpc_id" {
  value = aws_vpc.main.id
}
output "subnet_id" {
  value = aws_subnet.public.id
}
output "security_group_id" {
  value = aws_security_group.web.id
}
output "route53_name_servers" {
  value = aws_route53_zone.primary.name_servers
}

output "ec2_public_ip" {
  value = aws_eip.app_server.public_ip
}
