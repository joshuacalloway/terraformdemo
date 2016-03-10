
module "coreshoppertrak" {
  source = "./coreshoppertrak"
}


resource "aws_route53_record" "ftp" {
  zone_id = "${var.aws_route53_zone_id}"
#  zone_id = "${aws_route53_zone.default.id}"
  name = "ftp.${var.aws_route53_dns}"
  type = "CNAME"
    ttl = "5"
 
  weight = 10
  set_identifier = "ftp"
  records = ["${aws_instance.ftp.public_dns}"]
}

resource "aws_instance" "ftp" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    tags {
      Name = "ftp"
      Provisioned = "terraform"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]    
    key_name = "${var.aws_key_name}"
    associate_public_ip_address = true
    user_data = "${file("ftp-cloud-config.txt")}"
}

resource "aws_instance" "fetchserver" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    tags {
      Name = "fetchserver"
      Provisioned = "terraform"
    }
    vpc_security_group_ids = ["${module.coreshoppertrak.B-security-group.id}", "${aws_security_group.fetchserver.id}"]
    subnet_id = "${module.coreshoppertrak.B-subnet.id}"

    key_name = "${var.aws_key_name}"
    associate_public_ip_address = true
    user_data = "${file("base-cloud-config.txt")}"
}

resource "aws_security_group" "allow_all" {
  name = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
    
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }


  tags {
    Name = "allow_all"
  }
}

resource "aws_route53_zone" "default" {
  name = "${var.aws_route53_dns}"
}

resource "aws_route53_record" "retelimport" {
  zone_id = "${var.aws_route53_zone_id}"
#  zone_id = "${aws_route53_zone.default.id}"
  name = "retelimport.${var.aws_route53_dns}"
  type = "CNAME"
  ttl = "5"
  weight = 10
  set_identifier = "retelimport"
  records = ["${aws_instance.retelimport.private_dns}"]
}

resource "aws_route53_record" "retelimport-public" {
  zone_id = "${var.aws_route53_zone_id}"
#  zone_id = "${aws_route53_zone.default.id}"
  name = "retelimport-public.${var.aws_route53_dns}"
  type = "CNAME"
  ttl = "5"
  weight = 10
  set_identifier = "retelimport-public"
  records = ["${aws_instance.retelimport.public_dns}"]
}

resource "aws_route53_record" "fetchserver" {
  zone_id = "${var.aws_route53_zone_id}"
#  zone_id = "${aws_route53_zone.default.id}"
  name = "fetchserver.${var.aws_route53_dns}"
  type = "CNAME"
  ttl = "5"
  weight = 10
  set_identifier = "fetchserver"
  records = ["${aws_instance.fetchserver.private_dns}"]
}

resource "aws_route53_record" "fetchserver-public" {
  zone_id = "${var.aws_route53_zone_id}"
#  zone_id = "${aws_route53_zone.default.id}"
  name = "fetchserver-public.${var.aws_route53_dns}"
  type = "CNAME"
  ttl = "5"
  weight = 10
  set_identifier = "fetchserver-public"
  records = ["${aws_instance.fetchserver.public_dns}"]
}

resource "aws_security_group" "fetchserver" {
    name        = "fetchserver-security-group"
    description = "allow ftp ports between vpcs of fetchserver"
    vpc_id          = "${module.coreshoppertrak.B-vpc.id}"

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }


    tags {
        Name = "fetchserver-security-group"
        Provisioned = "terraform"
    }
}

resource "aws_security_group" "retelimport" {
    name        = "retelimport-security-group"
    description = "allow ftp ports between vpcs of fetchserver"
    vpc_id          = "${module.coreshoppertrak.A-vpc.id}"

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = 0
        to_port         = 40000
        protocol        = "tcp"
        cidr_blocks     = ["${var.aws_vpcB_cidr}"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags {
        Name = "retelimport-security-group"
        Provisioned = "terraform"
    }
}

resource "aws_instance" "retelimport" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    tags {
      Name = "retelimport"
      Provisioned = "terraform"
    }
    vpc_security_group_ids = ["${module.coreshoppertrak.A-security-group.id}", "${aws_security_group.retelimport.id}"]
    key_name = "${var.aws_key_name}"
    associate_public_ip_address = true
    subnet_id = "${module.coreshoppertrak.A-subnet.id}"
    user_data = "${file("retelimport-cloud-config.txt")}"
 }



