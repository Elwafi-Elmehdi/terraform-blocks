variable "instance_type" {
  description = "The EC2 instance type"
  default     = "t2.micro"
}

variable "ebs_root_volume_size" {
  description = "The EBS Root Volmue Size in GBs"
  default     = 8
}
variable "ebs_volume_type" {
  description = "EBS Volume Type"
  default     = "gp2"
}