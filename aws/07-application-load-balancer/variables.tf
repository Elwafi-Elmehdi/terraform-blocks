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
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "private subnet CIDR"
  type        = list(string)
  default     = ["10.0.8.0/22", "10.0.28.0/22"]
}

variable "instance_type" {
  description = "the default ec2 instance type"
  type        = string
  default     = "t2.micro"
}