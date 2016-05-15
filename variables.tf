### MANDATORY ###

variable "owner_tag" {
  description = "Who owns the instance."
  default = "n/a"
}

variable "environment_tag" {
  description = "Whether instance is production, test, development, etc."
  default = "Development"
}

variable "fund_tag" {
  description = "Fund for instance."
  default = "n/a"
}

variable "org_tag" {
  description = "Org for instance."
  default = "n/a"
}

variable "application_tag" {
  description = "Application tag."
  default = "RADIUS"
}

variable "clientdepartment_tag" {
  description = "Customer"
  default = "n/a"
}

###################################################################
# AWS configuration below
###################################################################

### MANDATORY ###

variable "key_name" {
  description = "SSH keypair name to use."
  default = "radius"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-west-2"
}

variable "aws_availability_zones" {
  description = "AWS region to launch servers."
  default = "us-west-2b"
}

variable "security_group_name" {
  description = "Name of security group to use in AWS."
  default = "app-radius-server"
}

###################################################################
# VPC configuration below
###################################################################

### MANDATORY ###

variable "vpc_id" {
  description = "VPC id"
}

variable "internal_cidr_blocks"{
  default = "0.0.0.0/0"
}

###################################################################
# AWS Subnet configuration
###################################################################

### MANDATORY ###
variable "aws_subnet_ids" {
  description = "AWS subnet IDs, comma seperated, for deployment."
}

###################################################################
# RADIUS configuration below
###################################################################

### MANDATORY ###

variable "aws_ami_id" {
  description = "Instance Amazon Machine Image ID"
  default = "ami-05cf2265"
}

variable "instance_type" {
  description = "Instance type."
  default = "t2.micro"
}

### MANDATORY ###

variable "instances" {
  description = "total number of instances"
  default = "1"
}

# the ability to add additional existing security groups. In our case
# we have consul running as agents on the box
variable "additional_security_groups" {
  default = ""
}

variable "aws_ebs_volume_path" {
  default = "/dev/xvda"
}

variable "aws_ebs_volume_size" {
  default = "10"
}

variable "aws_ebs_volume_encryption" {
  default = false
}
