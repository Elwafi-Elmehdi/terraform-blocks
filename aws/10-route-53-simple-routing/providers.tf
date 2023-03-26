provider "aws" {
  default_tags {
    tags = {
      "Terraform" = "True",
      "Project"   = "Simple routing policy with Route53"
    }
  }
}