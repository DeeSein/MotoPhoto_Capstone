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
  default     = ["10.0.0.0/26", "10.0.2.0/26"] # Adjust as needed
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.1.0/26", "10.0.3.0/26"] # Adjust as needed
}