provider "aws" {
    region = "eu-west-1"
    #shared_credentials_file = "./aws_credentials"
    #var.credentials
}

## create bucket encryption key
resource "aws_kms_key" "bucket_key" {
    #count = var.encryption ? 1 : 0
    description = "Server side bucket encryption."
#   deletion_window_in_days = 10
}

## create a S3 bucket for logging
resource "aws_s3_bucket" "bucket_log" {
    #count = var.logging ? 1 : 0
    bucket = "var.name_log_bucket"
    acl = "log-delivery-write"
}

## create S3 bucket
resource "aws_s3_bucket" "bucket" {
    bucket = var.name
    acl = "private" ## default ACL policy for newly created buckets

    ## enable/disable bucket versioning
    versioning {     
        enabled = true
    }
    
    ## enable/disable logging to a log bucket
    logging {
        target_bucket = "${aws_s3_bucket.bucket_log.id}"
        target_prefix = "logs/"
    }

    ## server side encryption
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = "${aws_kms_key.bucket_key.arn}"
                sse_algorithm  = "aws:kms"
            }
        }
    }

    ## enable/disable lifecycle policy


    ## enable/disable replication policy
}

## create IAM user with R/W access to bucket
resource "aws_iam_user" "bucket_user" {
    #count = var.iamuser ? 1 : 0
    name = "${var.name}_iam_user"
    path = "/" ## default path for newly created users
}

## create IAM user access key
resource "aws_iam_access_key" "bucket_user" {
   # count = var.iamuser ? 1 : 0
    user = "${aws_iam_user.bucket_user.name}"
}

## create R/W access policy for IAM user
resource "aws_iam_user_policy" "bucket_user_rw" {
   # count = var.iamuser ? 1 : 0

    name = "${var.name}_rw_policy"
    user = "${aws_iam_user.bucket_user.name}"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket.arn}"
    }
  ]
}
EOF

}