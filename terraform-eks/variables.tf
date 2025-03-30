variable "kubernetes_version" {
  default     = 1.32
  description = "kubernetes version"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default = "us-east-1"
  description = "aws region"
}

variable "db_username" {
  description = "Username for the RDS MySQL instance"
  type        = string
  default     = "crud_user"
}

variable "db_password" {
  description = "Password for the RDS MySQL instance"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
  default     = "crud_db"
}