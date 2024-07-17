# vpc name variable
variable "tagNameDate" {
  default = "17/07/2024" # Replace with the actual date
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
  default = "t2.micro" # Replace with your desired instance type
}

variable "key_name" {
  default = "vockey" # Replace with your key pair name
}

# Variables for RDS DB Instance
variable "rds_db_username" {
  description = "Username for the DB instance"
  default = "DB_User_1" # Replace with your MySQL username
}
variable "rds_db_password" {
  description = "Password for the DB instance"
  default = "password123" # Replace with your MySQL password
  sensitive = true
}
variable "rds_db_name" {
  description = "Name of the RDS DB instance"
  default = "MPB_Database" # Replace with your desired DB name
}

