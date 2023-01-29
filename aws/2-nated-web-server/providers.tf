provider "aws" {
  region = "eu-west-3"
  default_tags {
    tags = {
      Environment = "Test"
      Terraform        = "True"
      Project = "Nated Web Server"
    }
  }
}