terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.12.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "im-gexecik-u-xelaci-s3-backet"
    key    = "my-terraform/terraform.tfstate"
    region = "us-east-1"
    #profile = "default"
  }
}

provider "aws" {
  region     = "us-west-2"
 
}