provider "aws" {
  region = var.default_region
  default_tags {
    tags = {
      "Terrafrom" = "True"
      "Project"   = "Application Load Balancer with EC2"
    }
  }
}