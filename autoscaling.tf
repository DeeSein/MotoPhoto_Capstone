/* # create launch template from aws_instance.EC2_MotoPhoto instance
data "aws_instance" "ec2_moto_instance" {
  filter {
    name   = "image-id"
    values = [data.aws_ami.latest_linux2_ami.arn]
  }

  depends_on = [data.aws_instance.ec2_moto_instance]
} */

# create launch template
resource "aws_launch_template" "ec2_launch_template" {
  name          = "MPB_ec2-launch-template"
  instance_type = var.ec2_instance_type
  image_id      = data.aws_ami.latest_linux2_ami.id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  user_data = templatefile("${path.module}/userdata.sh", 
    {
      #make sure your variables are the same as your userdata.tpl
      rds_db_name     = var.rds_db_name
      rds_db_username = var.rds_db_username
      rds_db_password = var.rds_db_password
      rds_db_endpoint = aws_db_instance.rds.endpoint 
    }) 

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ec2_moto_instance_AS"
  }
}


# create autoscaling for ec2.tf with minimum 1, desired 2 and maximum 4 instances
resource "aws_autoscaling_group" "ec2_asg" {
  name                 = "ec2_asg"
  min_size             = 1
  desired_capacity     = 2
  max_size             = 4
  target_group_arns    = [aws_lb_target_group.ec2_tg.arn]
  vpc_zone_identifier  = [aws_subnet.public[0].id]

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = aws_launch_template.ec2_launch_template.latest_version
  }
}

# create autoscaling policy
resource "aws_autoscaling_policy" "ec2_asg_policy" {
  name                   = "ec2_asg_policy"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70
  }
}