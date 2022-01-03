variable "bucket_name" {
  description = "The name of the S3 bucket used to store the tfstate file. If not assigned, a name will be composed using `bucket_name_prefix` + `project_name` + `environment` + `region` + `bucket_name_suffix`"
  type        = string
  default     = ""
}

variable "bucket_region" {
  description = "If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee"
  default     = ""
}

variable "bucket_name_prefix" {
  description = "The prefix for the S3 bucket name in case `bucket_name` is not set."
  type        = string
  default     = "terraform"
}

variable "bucket_name_suffix" {
  description = "The suffix for the S3 bucket name in case `bucket_name` is not set."
  type        = string
  default     = "tfstate"
}

variable "bucket_prevent_destroy" {
  description = "A boolean that indicates if the S3 bucket can NOT be destroyed."
  default     = false
  type        = bool
}

variable "bucket_force_destroy" {
  description = "A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable"
  default     = false
  type        = bool
}

variable "bucket_versioning" {
  description = "A boolean that indicates if the S3 bucket uses versioning."
  default     = true
  type        = bool
}

variable "bucket_mfa_delete" {
  description = "A boolean that indicates that versions of S3 objects can only be deleted with MFA. ( Terraform cannot apply changes of this value; https://github.com/terraform-providers/terraform-provider-aws/issues/629 )"
  default     = false
  type        = bool
}

variable "bucket_acl" {
  type        = string
  description = "The canned ACL to apply to the S3 bucket"
  default     = "private"
}

variable "access_logs_bucket_name" {
  description = "The name for the S3 bucket name where access logs will be sent."
  type        = string
}

variable "project_name" {
  description = "The Name of the Project"
  type        = string
}

variable "environment" {
  description = "The Name of the Environment. If not empty will be appended to the bucket and DynamoDB names"
  default     = ""
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "append_region_to_name" {
  description = "Whether to add the region to the bucket and DynamoDB names"
  default     = false
  type        = bool
}

variable "dynamodb_read_capacity" {
  default     = 2
  description = "DynamoDB read capacity units"
}

variable "dynamodb_write_capacity" {
  default     = 2
  description = "DynamoDB write capacity units"
}

variable "dynamodb_prevent_destroy" {
  description = "A boolean that indicates if the DynamoDB can NOT be destroyed."
  default     = false
  type        = bool
}

variable "dynamodb_server_side_encryption_enabled" {
  description = "A boolean that indicates if the DynamoDB table uses encryption."
  default     = true
  type        = bool
}