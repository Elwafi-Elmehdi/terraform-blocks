provider "aws" {
  default_tags {
    tags = {
      Terraform = "True"
      Project   = "Two Tier architecture project"
    }
  }
}