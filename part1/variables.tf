variable "billing_account" {
  type        = string
  description = "The ID of the billing account this project belongs to."
  default     = "aaaaaa-bbbbbb-cccccc"
}

variable "bucket_name" {
  type        = string
  description = "The name of the Cloud Storage Bucket"
}

variable "project_id" {
  type        = string
  description = "The ID of the project"
}