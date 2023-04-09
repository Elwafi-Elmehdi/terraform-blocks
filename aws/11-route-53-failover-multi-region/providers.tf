provider "aws" {
  default_tags {
    tags = {
      "Terraform" = "True",
      "Project"   = "Simple routing policy with Route53"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  alias  = "failover"
  default_tags {
    tags = {
      "Terraform" = "True",
      "Project"   = "Simple routing policy with Route53"
    }
  }
}