resource "aws_instance" "data_migrate_ec2" {
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.public_subnet_az1.id 
  vpc_security_group_ids = [aws_security_group.app_server_security_group.id]
  associate_public_ip_address = true
  user_data =   user_data                   = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF
}
  depends_on = [aws_db_instance.database_instance]
  tags = {
    Name = "${var.project_name}-${var.environment}-data-migrate-ec2"
  }
}
