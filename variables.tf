# vpc name variable
variable "tagNameDate" {
  default = "19/07/2024" # Replace with the actual date
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
  default     = ["10.0.0.0/28", "10.0.0.16/28"] # Adjust as needed
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.0.32/28", "10.0.0.48/28"] # Adjust as needed
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
  default = "<User_1>" # Replace with your MySQL username
}
variable "rds_db_password" {
  description = "Password for the DB instance"
  default = "<password123>" # Replace with your MySQL password
  sensitive = true
}
variable "rds_db_name" {
  description = "Name of the RDS DB instance"
  default = "<Database>" # Replace with your desired DB name
}

# UserData Variables

variable "access_key" {
  default = "<your_access_key>"
  }

variable "secret_key" {
  default = "<your_secret_key>"
  }

variable "session_token" {
  default = "<your_token>"
  }

variable "region" {
  default     = "us-west-2"
}

# S3 Bucket Variables

variable "bucket_name" {
  default     = "motophotos3"
}