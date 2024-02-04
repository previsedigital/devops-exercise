#running 'terraform init && terraform apply -var-file=ohio.tfvars' would buuild this stack in Ohio.

region="us-east-2"

#new cidr range allows for the same 256 IP adresses as the London region. 
#repo states to not overlap with the dublin network which is eu-west-1 not the eu-west-2 of London. CIDR ranges for Dublin eu-west-1 is not known.

vpc-cidr = "10.10.20.0/24"
subnet-cidr-a = "10.10.20.0/27"
subnet-cidr-b = "10.10.20.32/27"
subnet-cidr-c = "10.10.20.64/27"
private-subnet-cidr = "10.10.20.96/27"