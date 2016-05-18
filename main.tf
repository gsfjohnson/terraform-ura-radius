provider "aws" {
  region = "${var.aws_region}"
}

##############################################################################
# RADIUS SERVER
##############################################################################

resource "aws_security_group" "radius" {
  name = "${var.security_group_name}"
  description = "Allow RADIUS from world, SSH from org"
  # vpc_id = "${var.vpc_id}"

  # ssh from org
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.org_cidr_blocks)}"]
  }

  # radius from world
  ingress {
    from_port = 1812
    to_port = 1814
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.security_group_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "user_data" {
  template = "${path.module}/templates/user-data.tpl"

  vars {
    num_nodes               = "${var.instances}"
    aws_ebs_volume_path     = "${var.aws_ebs_volume_path}"
    aws_sg                  = "${aws_security_group.radius.id}"
    aws_region              = "${var.aws_region}"
    aws_availability_zone  = "${var.aws_availability_zone}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "radius" {
  ami = "${var.aws_ami_id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${split(",", replace(concat(aws_security_group.radius.id, ",", var.additional_security_groups), "/,\\s?$/", ""))}"]
  associate_public_ip_address = true
  ebs_optimized = false
  key_name = "${var.key_name}"
  user_data = "${template_file.user_data.rendered}"
  availability_zone = "${var.aws_availability_zone}"

  tags {
    Name= "${format("ura-%s", var.aws_availability_zone)}"
    Owner = "${var.owner_tag}"
    Application = "${var.application_tag}"
    Environment = "${var.environment_tag}"
    Fund = "${var.fund_tag}"
    Org = "${var.org_tag}"
    ClientDepartment = "${var.clientdepartment_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name = "${var.aws_ebs_volume_path}"
    volume_size = "${var.aws_ebs_volume_size}"
  }
}

resource "aws_route53_record" "radius" {
  zone_id = "${var.aws_r53_zone_id}"
  name = "${format("%s.%s", var.aws_r53_record_name, var.aws_r53_zone_domain)}"
  type = "A"
  ttl = "300"
  records = ["${split(",", replace(concat(aws_instance.radius.public_ip, ",", var.aws_r53_record_addl_a), "/,\\s?$/", ""))}"]
}

resource "aws_route53_record" "awsadius" {
  zone_id = "${var.aws_r53_zone_id}"
  name = "${format("awsradius.%s", var.aws_r53_zone_domain)}"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.radius.public_ip}"]
}
