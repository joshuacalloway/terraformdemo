output "A-vpc.id" {
  value = "${aws_vpc.A.id}"
}
output "B-vpc.id" {
  value = "${aws_vpc.B.id}"
}

output "A-security-group.id" {
  value = "${aws_security_group.A.id}"
}
output "B-security-group.id" {
  value = "${aws_security_group.B.id}"
}

output "A-subnet.id" {
  value = "${aws_subnet.A.id}"
}
output "B-subnet.id" {
  value = "${aws_subnet.B.id}"
}

