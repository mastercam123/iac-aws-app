variable "aws_region" {
  description = "AWS Region for deployment"
  default     = "eu-central-1"
}
variable "management_role" {
  description = "ARN of the role to deploy into application account and to be assume from management account"
  default     = "arn:aws:iam::930736525289:role/terraform-execute"
}

variable "bucket_name" {
  description = "Name of the web bucket"
  default     = "hsn-test-web-2873"
}