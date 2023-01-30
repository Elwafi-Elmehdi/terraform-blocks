variable "aws_region" {
  default     = "eu-west-3"
  type        = string
  description = "the default aws region"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "the default instance class for ec2 instances"
}