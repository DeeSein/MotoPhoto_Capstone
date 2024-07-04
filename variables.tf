# vpc name variable
variable "tagNameDate" {
  default = "04/07/2024"
}

# VPC Variables
variable "cidr_blocks" {
  default = ["0.0.0.0/0"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["us-west-2a", "us-west-2b"] # Replace with your availability zones
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.0.0/26", "10.0.0.64/26"] # Adjust as needed
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.0.128/26", "10.0.0.192/26"] # Adjust as needed
}

# EC2 Variables
variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "vockey"
}

# Variables for RDS DB Instance
variable "db_username" {
  description = "Username for the DB instance"
  default = "root"
}
variable "db_password" {
  description = "Password for the DB instance"
  default = "password123"
  sensitive = true
}
variable "rds_db_name" {
  description = "Name of the RDS DB instance"
  default = "myDatabase"
}