provider "aws" {
    region = var.region
    #shared_credentials_file = "./aws_credentials"
}

## create S3 bucket
resource "aws_s3_bucket" "bucket" {
    bucket = var.name
    acl = "private" ## default ACL policy for newly created buckets

    ## enable/disable bucket versioning
    dynamic "versioning" {     
        for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]

        content {
            enabled = versioning.value.enabled
            mfa_delete = false
        }
    }
    
    ## enable/disable logging to a log bucket, log bucket must exists and be defined
    dynamic "logging" {
        for_each = length(keys(var.logging)) == 0 ? [] : [var.logging]

        content {            
            target_bucket = logging.value.log_bucket_id
            target_prefix = logging.value.log_bucket_prefix
        }
    }

    ## enable basic lifecycle to delete objects older than defined ammount of days
    dynamic "lifecycle_rule" {
        for_each = length(keys(var.life_cycle)) == 0 ? [] : [var.life_cycle]
        content {
            enabled = true
            tags = {
                "rule" = "bucket_cleanup"
                "autoclean" = "true"
            }
  
            expiration {
                days = var.life_cycle.days
            }
        }
    }

    ## enable/disable basic replication to a predefined bucket (with a provided IAM role policy)
    dynamic "replication_configuration" {
        for_each = length(keys(var.replication)) == 0 ? [] : [var.replication]

        content {
            role = aws_iam_role.replication[0].arn

            rules {
                id  = "bucket_replication"
                status = "Enabled"

                destination {
                    bucket = replication_configuration.value.replication_bucket_arn
                    storage_class = "STANDARD"
               }
            }
        }
    }

    ## enable/disable server side encryption
    dynamic "server_side_encryption_configuration" {
        for_each = length(keys(var.encryption)) == 1 ? [var.encryption] : []
        content {
            rule {
                apply_server_side_encryption_by_default {
                    kms_master_key_id = aws_kms_key.bucket_key[0].arn
                    sse_algorithm = "aws:kms"
                }
            }
        }
    }
}

## create bucket encryption key
resource "aws_kms_key" "bucket_key" {
    count = length(keys(var.encryption)) == 1 ? 1 : 0
    description = "Server side bucket encryption."
    deletion_window_in_days = var.encryption.key_duration
}

## create IAM user with R/W access to bucket
resource "aws_iam_user" "bucket_user" {
    count = var.iamuser == true ? 1 : 0
    name = "${var.name}_iam_user"
    path = "/"
}

## create IAM user access key
resource "aws_iam_access_key" "bucket_user" {
    count = var.iamuser == true ? 1 : 0
    user = aws_iam_user.bucket_user[count.index].name
}

## create R/W access policy for IAM user
resource "aws_iam_user_policy" "bucket_user_rw" {
    count = var.iamuser == true ? 1 : 0

    name = "${var.name}_iam_user_rw_policy"
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

resource "aws_iam_role" "replication" {
    count = length(keys(var.replication)) == 3 ? 1 : 0
    name = var.replication.replication_role_name

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
    count = length(keys(var.replication)) == 3 ? 1 : 0
    name = var.replication.replication_policy_name

    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.replication.replication_bucket_arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.replication.replication_bucket_arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${var.replication.replication_bucket_arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
    count = length(keys(var.replication)) == 3 ? 1 : 0
    role = aws_iam_role.replication[count.index].name
    policy_arn = aws_iam_policy.replication[count.index].arn
}