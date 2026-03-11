terraform {
required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.34.0"
    }
  }

  backend "s3" {
    bucket = "bucket-store-tfstate"
    key="terraform.tfstate"
    region="eu-north-1"
    dynamodb_table = "tws-tfstate-table"
  }
}
