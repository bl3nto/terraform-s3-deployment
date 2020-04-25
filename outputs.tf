##  Terraform S3 bucket deployment module will output the following:
##  - bucket name
##  - bucket region
##  - bucket Amazon Resource Names (ARN)
##  - ARN of a logging bucet (if created)
##  - IAM user details with full R/W permissions on a bucket (if created)

output "bucket_name" {
    description = "Name of the created bucket."
    value = element(concat(aws_s3_bucket.bucket .*.id, list("")), 0)
}

output "bucket_region" {
    description = "Region in which the bucked it hosted."
    value = element(concat(aws_s3_bucket.bucket .*.region, list("")), 0)
}

output "bucket_arn" {
    description = "Bucket ARN to uniquely identify it as an AWS resource."
    value = element(concat(aws_s3_bucket.bucket .*.arn, list("")), 0)
}

output "bucket_log" {
    description = "ARN of log bucket if it is created."
    value = "TODO"
}

output "iam_user" {
    description = "IAM user details for bucket access, if it is created."
    value = "TODO"
}