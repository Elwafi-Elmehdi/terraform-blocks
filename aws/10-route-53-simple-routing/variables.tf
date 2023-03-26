variable "hosted_zone_name" {
  type = string
}
variable "hosted_zone_type" {
  type    = string
  default = "public"
}

variable "instance_type" {
  default = "t2.micro"
}