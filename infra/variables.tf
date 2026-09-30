variable "aws_region" {
  default = "eu-north-1"
}
variable "vpc_cidr" {
  default = "10.1.0.0/16"
}
variable "public_subnet_cidr" {
  default = "10.1.1.0/24"
}
variable "my_ip" {
  description = "Your public IP in CIDR form, e.g. 197.210.x.x/32, for SSH access"
}
variable "domain_name" {
  description = "Your domain name for the Route 53 hosted zone"
}
