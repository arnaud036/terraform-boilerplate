
# Chicken and egg problems, but helpful while bootstrapping a new AWS account. Make sure to use ./bootstrap script
module "aws_bootstrap" {
  source = "../../../modules/companyxyz-aws-bootstrap"

  tfstate_bucket         = "tf-state-companyxyz-dev"
  tfstate_dynamodb_table = "tf-state-companyxyz-dev"
  mfa_enabled            = false
}
