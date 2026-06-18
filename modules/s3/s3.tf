# modules/s3/s3.tf
# This file defines the S3 bucket resource.

resource "aws_s3_bucket" "imported_bucket" {
  bucket = var.bucket_name

  # CRITICAL: No 'tags' block here, as your manually created bucket has no tags.
}
