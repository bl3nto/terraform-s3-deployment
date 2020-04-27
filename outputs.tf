output "bucket_id" {
    description = "Name of the created bucket."
    value = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
    description = "ARN of the created bucket."
    value = aws_s3_bucket.bucket.arn
}

output "bucket_region" {
    description = "Region in which the bucked it hosted."
    value = aws_s3_bucket.bucket.region
}

output "iam_user_name" {
    description = "Name of the IAM user."
    value = element(concat(aws_iam_user.bucket_user.*.name, list("")), 0)
}

output "iam_user_id" {
    description = "Access ID of the IAM user."
    value = element(concat(aws_iam_access_key.bucket_user_key.*.id, list("")), 0)
}

output "iam_user_key" {
    description = "Access key of the IAM user."
    value = element(concat(aws_iam_access_key.bucket_user_key.*.secret, list("")), 0)
}

output "bucket_key_arn" {
    description = "Server-side encryption key ARN."
    value =  element(concat(aws_kms_key.bucket_key.*.arn, list("")), 0)
}

output "bucket_key_id" {
    description = "Server-side encryption key ID."
    value =  element(concat(aws_kms_key.bucket_key.*.key_id, list("")), 0)
}