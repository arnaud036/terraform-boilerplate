# variables
variable "tfstate_dynamodb_table" {
  description = "Name of the dynamo db table used to lock the tfstate files"
  default     = "terraform-state-lock"
}

variable "tfstate_bucket" {
  description = "Name of the s3 bucket used to store tfstate files"
  # Should be something like '<accountname>-tfstate'
}

variable "mfa_enabled" {
  description = "Configure if this account uses MFA for requests."
  default     = true
}
