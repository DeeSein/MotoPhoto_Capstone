# create a RDS for my Wordpress 
# create DB Subnet Group
resource "aws_db_subnet_group" "privat_rds" {
  name        = "rds"
  description = "rds subnet"
  subnet_ids  = [aws_subnet.private[0].id, aws_subnet.private[1].id]

  tags = {
    Name = "MotoPhoto_prv_group ${var.tagNameDate}"
  }
}

# create RDS
resource "aws_db_instance" "rds" {
  allocated_storage            = 10
  storage_type                 = "gp2"
  engine                       = "mysql"
  engine_version               = "8.0.35"
  instance_class               = "db.t3.micro"
  identifier                   = "moto-photo-rds"   
  db_name                      = var.rds_db_name
  username                     = var.rds_db_username
  password                     = var.rds_db_password
  db_subnet_group_name         = aws_db_subnet_group.privat_rds.name
  vpc_security_group_ids       = [aws_security_group.rds_sg.id]
  multi_az                     = false
  snapshot_identifier          = null
  skip_final_snapshot          = true

  tags = {
        Name = "MotoPhoto_rds ${var.tagNameDate}"
  }
}

data "aws_db_instance" "rds" {
  db_instance_identifier = aws_db_instance.rds.identifier
  depends_on = [aws_db_instance.rds]
}
  
# get DB Name, username, password, endpoint from RDS above
output "rds_db_name" {
    value = var.rds_db_name
}
output "rds_db_username" {
    value = var.rds_db_username
}
output "rds_db_password" {
    value = var.rds_db_password
    sensitive = true
}
output "rds_db_endpoint" {
    value = aws_db_instance.rds.endpoint
}
