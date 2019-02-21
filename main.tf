# Create CloudFront Origin Access Identity for allowing only CloudFront access to static website bucket
# https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
resource "aws_cloudfront_origin_access_identity" "origin-access-identity" {
  comment = "${var.cloudfront_origin_access_identity_comment}"
}

# Create S3 bucket for serving static website
resource "aws_s3_bucket" "static-website-bucket" {
  bucket = "${var.static_website_bucket_name}"

  acl = "private"

  force_destroy = "${var.static_website_bucket_force_destroy}"

  tags = {
    Terraform   = "true"
    Name        = "${var.static_website_bucket_name}"
    Environment = "${var.environment}"
  }
}

# Attach Bucket Policy to S3 Bucket
resource "aws_s3_bucket_policy" "static-website-bucket-policy" {
  bucket = "${aws_s3_bucket.static-website-bucket.id}"
  policy = "${data.aws_iam_policy_document.static-website-bucket-policy-document.json}"
}

# Generate bucket policy for static website bucket
# It grants CloudFront Origin Access Identity the permission to access to objects in the bucket
# https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html#example-bucket-policies-use-case-6
data "aws_iam_policy_document" "static-website-bucket-policy-document" {
  statement {
    sid = "Grant CloudFront Origin Access Identity access to objects in bucket(${var.static_website_bucket_name})"

    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type = "CanonicalUser"

      identifiers = [
        "${aws_cloudfront_origin_access_identity.origin-access-identity.s3_canonical_user_id}",
      ]
    }

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.static-website-bucket.id}/*",
    ]
  }
}
