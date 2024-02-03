# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

# # vpc variables
variable "vpc_cidr" {
description = "vpc cidr block"
type        = string
}

variable "public_subnet_az1_cidr" {
description = "public subnet az1 cidr block"
type        = string
}

variable "public_subnet_az2_cidr" {
description = "public subnet az2 cidr block"
type        = string
}

variable "private_app_subnet_az1_cidr" {
description = "private app subnet az1 cidr block"
type        = string
}

variable "private_app_subnet_az2_cidr" {
description = "private app subnet az2 cidr block"
type        = string
}

variable "private_data_subnet_az1_cidr" {
description = "private data subnet az1 cidr block"
type        = string
}

variable "private_data_subnet_az2_cidr" {
description = "private data subnet az2 cidr block"
type        = string
}

# ec2 instance migrate variables
variable "amazon_linux_ami_id" {
  description = "The ID of the AMI to use for the EC2 instance."
  type        = string
}

variable "ec2_instance_type" {
  description = "The EC2 instance type."
  type        = string
}

