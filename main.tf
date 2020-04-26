provider "aws" {
    region = "eu-west-1"
    #shared_credentials_file = "./aws_credentials"
    #var.credentials
}

## create bucket encryption key
#resource "aws_kms_key" "bucket_key" {
#    description = "Server side bucket encryption."
    #deletion_window_in_days = 10
#}

## create S3 bucket
resource "aws_s3_bucket" "bucket" {
    bucket = var.name
    acl = "private" ## default ACL policy for newly created buckets

    ## enable/disable bucket versioning
    dynamic "versioning" {     
        for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]

        content {
            enabled = versioning.value.enabled
            mfa_delete = versioning.value.mfa_delete
        }
    }
    
    ## enable/disable logging to a log bucket, log bucket must exists and be defined
    dynamic "logging" {
        for_each = length(keys(var.logging)) == 0 ? [] : [var.logging]

        content {            
            target_bucket = logging.value.log_bucket
            target_prefix = logging.value.log_prefix
        }
    }

    ## enable basic lifecycle to delete objects older than defined ammount of days
    dynamic "lifecycle_rule" {
        for_each = length(keys(var.life_cycle)) == 0 ? [] : [var.life_cycle]
        content {
            enabled = var.life_cycle.enabled
            tags = {
                "rule" = "bucket_cleanup"
                "autoclean" = "true"
            }
  
            expiration {
                days = var.life_cycle.days
            }
        }
    }

    ## enable/disable server side encryption
    #dynamic "server_side_encryption_configuration" {
    #    for_each = values(var.encryption).enabled == false ? [] : [var.encryption] 
    #    content {
    #        rule {
    #            apply_server_side_encryption_by_default {
    #                kms_master_key_id = aws_kms_key.bucket_key.arn
    #                sse_algorithm  = "aws:kms"
    #            }
    #        }
    #    }
    #}

    ## enable/disable lifecycle policy


    ## enable/disable replication policy
}

## create IAM user with R/W access to bucket
resource "aws_iam_user" "bucket_user" {
    count = var.iamuser ? 1 : 0
    name = "${var.name}_iam_user"
    path = "/"
}

## create IAM user access key
resource "aws_iam_access_key" "bucket_user" {
    count = var.iamuser ? 1 : 0
    user = aws_iam_user.bucket_user[count.index].name
}

## create R/W access policy for IAM user
resource "aws_iam_user_policy" "bucket_user_rw" {
    count = var.iamuser ? 1 : 0

    name = "${var.name}_rw_policy"
    user = aws_iam_user.bucket_user[count.index].name

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