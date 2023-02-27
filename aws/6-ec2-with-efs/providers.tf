provider "aws" {
  region = var.default_region
  default_tags {
    tags = {
      Terraform = "True"
      Project   = "EFS with Multiple EC2 Instances"
    }
  }
}