provider "aws" {
    region = "eu-west-1"
}

resource "aws_kms_key" "bucket_key" {
    description = "Server side bucket encryption."
##   deletion_window_in_days = 10
}
resource "aws_iam_user" "bucket_user" {
    name = "${env.name}_iam_user"
    path = "/" ## default path for newly created users
}

resource "aws_iam_access_key" "bucket_user" {
    user = "${aws_iam_user.bucket_user.name}"
}

resource "aws_iam_user_policy" "bucket_user_rw" {
    name = "${env.name}_rw_policy"
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
      "Resource": "*" ## ovdje ide ARN novokreiranog bucketa
    }
  ]
}
EOF

}
resource "aws_s3_bucket" "bucket" {
    bucket = "${env.name}"
    acl = "private" ## default ACL policy for newly created buckets

    ## enable/disable bucket versioning
    dynamic "versioning" {
        enabled = "${env.versioning}"
    }

    dynamic "lifecycle_rule" {
        id      = "tmp"
        prefix  = "tmp/"
        enabled = true

        expiration {
            date = "2016-01-12"
        }
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
}