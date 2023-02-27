provider "aws" {
  region = var.default_region
  default_tags {
    tags = {
      Terraform = "True"
      Project   = "Two Tier architecture project"
    }
  }
}