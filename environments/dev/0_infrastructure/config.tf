
terraform {
  required_version = "1.4.6"
  backend "s3" {
    bucket         = "tf-state-companyxyz-dev"
    key            = "us-west-2/dev/infrastructure.tfstate"
    encrypt        = true
    dynamodb_table = "tf-state-companyxyz-dev"
    region         = "us-west-2"
    profile        = "companyxyz-dev"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "companyxyz-dev"
}
