variable "cloudfront_origin_access_identity_comment" {
  type        = "string"
  description = "The comment of CloudFront Origin Acess Identity that allows only CloudFront access to static website bucket"
}

variable "static_website_bucket_name" {
  type        = "string"
  description = "The name of S3 bucket that is for serving static website"
}

variable "static_website_bucket_force_destroy" {
  type        = "string"
  default     = "false"
  description = "Allow destroying the S3 bucket without error. You can force S3 bucket to delete even if it has some objects."
}

variable "environment" {
  type        = "string"
  description = "Setting environment like production,stating and development"
}
