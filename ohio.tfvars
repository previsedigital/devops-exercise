# environment variables
region       = "us-east-2"
project_name = "previse-app"
environment  = "dev"

# # vpc variables
vpc_cidr                     = "10.0.0.0/16"
public_subnet_az1_cidr       = "10.0.0.0/24"
public_subnet_az2_cidr       = "10.0.1.0/24"
private_app_subnet_az1_cidr  = "10.0.2.0/24"
private_app_subnet_az2_cidr  = "10.0.3.0/24"
private_data_subnet_az1_cidr = "10.0.4.0/24"
private_data_subnet_az2_cidr = "10.0.5.0/24"

# ec2 instance migrate variables
amazon_linux_ami_id = "ami-0b25f6ba2f4419235"
ec2_instance_type   = "t2.micro"