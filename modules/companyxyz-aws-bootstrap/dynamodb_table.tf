# DynamoDB

resource "aws_dynamodb_table" "terraform_statelock" {
  name           = var.tfstate_dynamodb_table
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
