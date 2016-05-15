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
    cidr_blocks = ["${split(",", var.internal_cidr_blocks)}"]
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
    aws_availability_zones  = "${var.aws_availability_zones}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "radius" {
  image_id = "${var.aws_ami_id}"
  instance_type = "${var.instance_type}"
  security_groups = ["${split(",", replace(concat(aws_security_group.radius.id, ",", var.additional_security_groups), "/,\\s?$/", ""))}"]
  associate_public_ip_address = false
  ebs_optimized = false
  key_name = "${var.key_name}"
  #iam_instance_profile = "${aws_iam_instance_profile.radius.id}"
  user_data = "${template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name = "${var.aws_ebs_volume_path}"
    volume_size = "${var.aws_ebs_volume_size}"
  }
}

resource "aws_autoscaling_group" "radius" {
  availability_zones = ["${split(",", var.aws_availability_zones)}"]
  #vpc_zone_identifier = ["${split(",", var.aws_subnet_ids)}"]
  max_size = "${var.instances}"
  min_size = "${var.instances}"
  desired_capacity = "${var.instances}"
  default_cooldown = 30
  force_delete = true
  launch_configuration = "${aws_launch_configuration.radius.id}"

  tag {
    key = "Name"
    value = "${format("ura-%s", var.aws_availability_zones)}"
    propagate_at_launch = true
  }
  tag {
    key = "Owner"
    value = "${var.owner_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "Application"
    value = "${var.application_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${var.environment_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "Fund"
    value = "${var.fund_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "Org"
    value = "${var.org_tag}"
    propagate_at_launch = true
  }
  tag {
    key = "ClientDepartment"
    value = "${var.clientdepartment_tag}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
