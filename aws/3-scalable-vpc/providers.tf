provider "aws" {
  region = "eu-west-3"
  default_tags {
    tags = {
      Environment = "Terraform"
      Terraform   = "True"
      Project     = "Scalble and HA VPC"
    }
  }
}