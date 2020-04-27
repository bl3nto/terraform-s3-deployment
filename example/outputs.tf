output "bucket_id" {
    description = "Name of the created bucket."
    value = module.s3_bucket_deployment.bucket_id
}

output "bucket_arn" {
    description = "ARN of the created bucket."
    value = module.s3_bucket_deployment.bucket_arn
}

output "bucket_region" {
    description = "Region in which the bucked it hosted."
    value = module.s3_bucket_deployment.bucket_region
}

output "iam_user_name" {
    description = "Name of the IAM user."
    value = module.s3_bucket_deployment.iam_user_name
}

output "iam_user_id" {
    description = "Access ID of the IAM user."
    value = module.s3_bucket_deployment.iam_user_id
}

output "iam_user_key" {
    description = "Access key of the IAM user."
    value = module.s3_bucket_deployment.iam_user_key
}

output "bucket_key_arn" {
    description = "Server-side encryption key ARN."
    value = module.s3_bucket_deployment.bucket_key_arn
}

output "bucket_key_id" {
    description = "Server-side encryption key ID."
    value = module.s3_bucket_deployment.bucket_key_id
}