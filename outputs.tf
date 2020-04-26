##  Terraform S3 bucket deployment module will output the following:
##  - bucket name
##  - bucket region
##  - bucket Amazon Resource Names (ARN)
##  - IAM user details with full R/W permissions on a bucket (if created)
##  - Server-side encryption key details

output "bucket_name" {
    description = "Name of the created bucket."
    value = element(concat(aws_s3_bucket.bucket.*.id, list("")), 0)
}

output "bucket_region" {
    description = "Region in which the bucked it hosted."
    value = element(concat(aws_s3_bucket.bucket.*.region, list("")), 0)
}

output "bucket_arn" {
    description = "Bucket ARN to uniquely identify it as an AWS resource."
    value = element(concat(aws_s3_bucket.bucket.*.arn, list("")), 0)
}

output "iam_user" {
    description = "IAM username for bucket access, if it is created."
    value = element(concat(aws_iam_user.bucket_user.*.name, list("")), 0)
}

output "iam_user_key" {
    description = "IAM secret key, if it is created."
    value = element(concat(aws_iam_access_key.bucket_user.*.secret, list("")), 0)
}

output "bucket_key_arn" {
    description = "Server-side encryption key ARN"
    value =  element(concat(aws_kms_key.bucket_key.*.arn, list("")), 0)
}

output "bucket_key_id" {
    description = "Server-side encryption key ID"
    value =  element(concat(aws_kms_key.bucket_key.*.key_id, list("")), 0)
}