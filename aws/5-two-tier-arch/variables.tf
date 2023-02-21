variable "vpc_cidr" {
  description = "VPC default CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "default_region" {
  description = "The Default region"
  type        = string
  default     = "eu-west-3"
}

variable "public_subnets_cidr" {
  description = "Public subnet CIDR"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnets_cidr" {
  description = "private subnet CIDR"
  type        = list(string)
  default     = ["10.0.8.0/22"]
}

variable "instance_type" {
  description = "Default ec2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "rds_username" {
  description = "Default user"
}

variable "rds_password" {
  description = "User's password"
}

variable "rds_instance_type" {
  description = "Default RDS instance type"
  default     = "db.t3.micro"
  type        = string
}

variable "rds_engine_type" {
  description = "Database engine"
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "Database engine version"
  default     = "5.7"
}