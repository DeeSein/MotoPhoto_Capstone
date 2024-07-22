# create a application loadbalancer for the webserver
resource "aws_alb" "EC2_MotoPhoto" {
  name               = "EC2-MotoPhoto"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  security_groups    = [aws_security_group.wordpress_sg.id]
  
  enable_deletion_protection = false

  tags = {
    Name = "EC2-MotoPhoto"
  }
}

# create a listener for the ALB
resource "aws_alb_listener" "EC2_MotoPhoto" {
  load_balancer_arn = "${aws_alb.EC2_MotoPhoto.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.ec2_tg.arn}"
    type             = "forward"
  }
}

# create target group for autoscaling
resource "aws_lb_target_group" "ec2_tg" {
  name     = "ec2-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "instance"

  tags = {
    Name = "ec2-tg ${var.tagNameDate}"
  }
}

# connect autoscaling to alb
resource "aws_autoscaling_attachment" "bar" {
  autoscaling_group_name = aws_autoscaling_group.example.id
  lb_target_group_arn    = aws_lb_target_group.ec2_tg.arn
}

resource "aws_alb_target_group_attachment" "MotoPhoto" {
  target_group_arn = aws_lb_target_group.ec2_tg.arn
  target_id        = aws_instance.EC2_MotoPhoto[0].id
  port             = 80 
}

resource "aws_lb_listener" "MPB_listener" {
    load_balancer_arn = "${aws_alb.EC2_MotoPhoto.arn}"
    port              = "80"
    protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ec2_tg.arn
    type             = "forward"
  }
}

