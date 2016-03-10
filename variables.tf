variable "aws_route53_zone_id" {}
variable "aws_route53_dns" {}

variable "aws_vpcA_cidr" {
  default = "10.0.5.0/24"
}
variable "aws_vpcB_cidr" {
  default = "10.0.11.0/24"
}
variable "aws_key_name" {}
variable "aws_key_path" {}
variable "aws_secret_key" {}
variable "aws_access_key" {}
variable "aws_region" {
  default = "eu-west-1"
}
variable "amis" {
  default = {
    eu-west-1 = "ami-e1398992"
    us-west-2 = "ami-63b25203"
    us-east-1 = "ami-8fcee4e5" 
  }
}
