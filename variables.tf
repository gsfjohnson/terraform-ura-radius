### MANDATORY ###

variable "owner_tag" {
  description = "Who owns the instance."
}

variable "environment_tag" {
  description = "Whether instance is production, test, development, etc."
  default = "Development"
}

variable "fund_tag" {
  description = "Fund for instance."
}

variable "org_tag" {
  description = "Org for instance."
}

variable "application_tag" {
  description = "Application tag."
  default = "RADIUS"
}

variable "clientdepartment_tag" {
  description = "Customer"
}

###################################################################
# AWS configuration below
###################################################################

### MANDATORY ###

variable "key_name" {
  description = "SSH keypair name to use."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-west-2"
}

variable "aws_availability_zone" {
  description = "AWS AZ to launch servers."
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

#variable "vpc_id" {
#  description = "VPC id"
#}

variable "org_cidr_blocks"{
  description = "Organizations cidr blocks"
}

###################################################################
# AWS Subnet configuration
###################################################################

### MANDATORY ###
#variable "aws_subnet_ids" {
#  description = "AWS subnet IDs, comma seperated, for deployment."
#}

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

variable "aws_r53_zone_id" {
  description = "AWS Route53 Zone ID, e.g. Z1XPTMOSAOMS"
}

variable "aws_r53_zone_domain" {
  description = "AWS Route53 Zone Domain, e.g. example.org"
}

variable "aws_r53_record_name" {
  description = "Hostname to use in Zone, e.g. radius"
}

variable "aws_r53_record_addl_a" {
  description = "Addl addresses for record"
  default = ""
}
