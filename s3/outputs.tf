output "bucket_id" {
  description = "ID of the S3 bucket used by lambda"

  value = aws_s3_bucket.lambda_bucket.id
}
