locals {
  # The name of the EC2 instance
  name = "MotoPhoto ${var.tagNameDate}"
  owner = "MotoPhoto"
}

### Select the newest AMI

data "aws_ami" "latest_linux2_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


### Create an EC2 instance

resource "aws_instance" "EC2_MotoPhoto" {
  ami                         = data.aws_ami.latest_linux2_ami.id
  instance_type               = var.ec2_instance_type
  availability_zone           = var.availability_zones[0]
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
  subnet_id                   = aws_subnet.public[0].id
  count = 1
  
  tags = {
    Name = "EC2_MotoPhoto_${var.tagNameDate}"
  }
  #set up with userdata template to collect variables
  user_data = templatefile("${path.module}/userdata.sh", 
    {
      #make sure your variables are the same as your userdata.tpl
      rds_db_name     = var.rds_db_name
      rds_db_username = var.rds_db_username
      rds_db_password = var.rds_db_password
      rds_db_endpoint = aws_db_instance.rds.endpoint 
    })  
}

