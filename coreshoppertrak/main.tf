
resource "aws_route_table_association" "A" {
  subnet_id = "${aws_subnet.A.id}"
  route_table_id = "${aws_route_table.A.id}"
}

resource "aws_route_table_association" "B" {
  subnet_id = "${aws_subnet.B.id}"
  route_table_id = "${aws_route_table.B.id}"
}


resource "aws_vpc_peering_connection" "A" {
    peer_owner_id = "634856412072"
    peer_vpc_id = "${aws_vpc.A.id}"
    vpc_id = "${aws_vpc.B.id}"
    auto_accept = true
    tags {
        Name = "A-vpc-connection"
        Provisioned = "terraform"
    }
}

resource "aws_route_table" "A" {
  vpc_id = "${aws_vpc.A.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.A.id}"
  }
 
  tags {
    Name = "A"
    Provisioned = "terraform"
  }
}

resource "aws_route_table" "B" {
  vpc_id = "${aws_vpc.B.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.B.id}"
  }
 
  tags {
    Name = "B"
    Provisioned = "terraform"
  }
}

resource "aws_route" "peerA" {
    route_table_id = "${aws_route_table.A.id}"
    destination_cidr_block = "${var.aws_vpcB_cidr}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.A.id}"
    depends_on = ["aws_route_table.A", "aws_route_table.B"]    
}

resource "aws_route" "peerB" {
    route_table_id = "${aws_route_table.B.id}"
    destination_cidr_block = "${var.aws_vpcA_cidr}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.A.id}"
    depends_on = ["aws_route_table.B", "aws_route_table.A"]    
}

resource "aws_internet_gateway" "A" {
  vpc_id = "${aws_vpc.A.id}"

  tags {
    Name = "A gateway"
    Provisioned = "terraform"
  }
}

resource "aws_internet_gateway" "B" {
  vpc_id = "${aws_vpc.B.id}"

  tags {
    Name = "B gateway"
    Provisioned = "terraform"
  }
}
resource "aws_vpc" "B" {
    cidr_block           = "${var.aws_vpcB_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags {
        "Name" = "vpcB"
        "Provisioned" = "terraform"
    }
}

resource "aws_vpc" "A" {
    cidr_block           = "${var.aws_vpcA_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags {
        "Name" = "vpcA"
        "Provisioned" = "terraform"
    }
}

resource "aws_subnet" "A" {
    vpc_id                  = "${aws_vpc.A.id}"
    cidr_block              = "${var.aws_vpcA_cidr}"
    availability_zone       = "eu-west-1a"
    map_public_ip_on_launch = false

    tags {
        "Name" = "subnet-A"
        "Provisioned" = "terraform"
    }
}


resource "aws_subnet" "B" {
    vpc_id                  = "${aws_vpc.B.id}"
    cidr_block              = "${var.aws_vpcB_cidr}"
    availability_zone       = "eu-west-1a"
    map_public_ip_on_launch = false

    tags {
        "Name" = "subnet-B"
        "Provisioned" = "terraform"
    }
}

resource "aws_security_group" "B" {
    name        = "B-security-group"
    description = "VPC B, only allow ssh in and all outgoing"
    vpc_id                  = "${aws_vpc.B.id}"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }


    tags {
        "Name" = "default"
        "Provisioned" = "terraform"
    }

}

resource "aws_security_group" "A" {
    name        = "A-security-group"
    description = "VPC A, only allow ssh in and all outgoing"
    vpc_id                  = "${aws_vpc.A.id}"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }


    tags {
        "Name" = "default"
        "Provisioned" = "terraform"
    }

}
