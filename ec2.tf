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
    Name = "EC2_MotoPhoto"
  }
  user_data = file("userdata.sh")
  #user_data = data.template_file.ec2userdatatemplate.rendered
}

/* data "template_file" "ec2userdatatemplate" {
  template = file("userdata.sh")

  vars = {
    rds_endpoint       = replace("${data.aws_db_instance.mysql_data.endpoint}", ":3306", "")
    rds_username       = "${var.db_username}"
    rds_password       = "%{var.db_password}"
    rds_db_name        = "%{data.aws_db_instance.mysql_data.db_name}"
  }
}

output "ec2rendered" {
  value = "${data.template_file.ec2userdatatemplate.rendered}"
}

output "public_ip" {
  value = aws_instance.instance[0].public_ip
}   */