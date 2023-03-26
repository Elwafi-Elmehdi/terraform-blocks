provider "aws" {
  default_tags {
    tags = {
      Terraform   = "True"
      Project     = "Terraform S3 Website Project"
      Environment = "Dev"
    }
  }
}