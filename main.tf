provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-cidr-a
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "subnet-b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-cidr-b
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "subnet-c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-cidr-c
  availability_zone = "${var.region}c"
}

#Adding private subnet

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet-cidr
  map_public_ip_on_launch = false
}

resource "aws_route_table" "public-subnet-route-table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private-subnet-route-table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "public-subnet-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.public-subnet-route-table
}

#Adding private NAT

resource "aws_route" "private-nat-gateway" {
  route_table_id         = aws_route_table.private-subnet-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "subnet-a-route-table-association" {
  subnet_id      = aws_subnet.subnet-a.id
  route_table_id = aws_route_table.public-subnet-route-table.id
}

resource "aws_route_table_association" "subnet-b-route-table-association" {
  subnet_id      = aws_subnet.subnet-b.id
  route_table_id = aws_route_table.public-subnet-route-table.id
}

resource "aws_route_table_association" "subnet-c-route-table-association" {
  subnet_id      = aws_subnet.subnet-c.id
  route_table_id = aws_route_table.public-subnet-route-table.id
}

resource "aws_route_table_association" "subnet-private-route-table-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-subnet-route-table.id
}

resource "aws_instance" "instance" {
  ami                         = "ami-0ad32127d6f7eb18a"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [ aws_security_group.security-group.id ]
  subnet_id                   = aws_subnet.subnet-a.id
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF
}


#Adding Elastic IP and NAT gateway

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.subnet-a.*.id, 0)
  depends_on    = [aws_internet_gateway.igw]
}

#Adding a autoscalinggroup which will allow for up to 3 instances of the nginx server

resource "aws_launch_configuration" "launch_config" {
  name          = "nginx-server"
  image_id      = "ami-0ad32127d6f7eb18a"
  instance_type = "t3.micro"
  security_groups = [ aws_security_group.security-group.id ]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              service nginx start
              EOF
}

resource "aws_autoscaling_group" "asg" {
  name                      = "nginx-autoscaling"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  launch_configuration      = aws_launch_configuration.launch_config.name
  vpc_zone_identifier       = [aws_subnet.subnet-a.id,aws_subnet.subnet-b.id,aws_subnet.subnet-c.id]

}

#Add a loadbalancer and target group in order to split traffic across the 3 instances.

resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb" "nginx_lb" {
  name               = "nginx-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-a.id, aws_subnet.subnet-b.id, aws_subnet.subnet-c.id]

  tags = {
    Name = "NGINXLB"
  }
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  alb_target_group_arn   = aws_lb_target_group.nginx_target_group.arn
}

resource "aws_security_group" "security-group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

output "nginx_domain" {
  value = aws_instance.instance.public_dns
}
