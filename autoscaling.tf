# creating launch template via terraform
data "aws_instance" "existing_instance" {
  instance_id = aws_instance.EC2_MotoPhoto[0].id
}

resource "aws_launch_template" "example" {
  name_prefix            = "MotoPhoto-launch-template"
  instance_type          = var.ec2_instance_type
  image_id               = data.aws_ami.latest_linux2_ami.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  user_data              = base64encode(templatefile("${path.module}/userdata.sh", {
      #make sure your variables are the same as your userdata.tpl
      rds_db_name     = var.rds_db_name
      rds_db_username = var.rds_db_username
      rds_db_password = var.rds_db_password
      rds_db_endpoint = aws_db_instance.rds.endpoint 
    }))

  tags = {
    Name = "MotoPhoto-launch-template"
  }
}

resource "aws_autoscaling_group" "example" {
  name                 = "MotoPhoto-autoscaling-group"
  vpc_zone_identifier = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  min_size             = 1
  max_size             = 4
  desired_capacity     = 2

  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }

  tag {
    key                 = var.key_name
    value               = "MotoPhoto-asg"
    propagate_at_launch = true
  }
}

# create autoscaling policy
resource "aws_autoscaling_policy" "ec2_asg_policy" {
  name                   = "ec2_asg_policy"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.example.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70
  }
}