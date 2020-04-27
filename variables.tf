##  Variables used by Terraform S3 bucket deployment module:
##  - bucket name
##  - logging
##  - object lifecycle
##  - object replication
##  - versioning
##  - encryption
##  - option to create a dedicated IAM user with IAM policy for full r/w access on the created bucket(s)

variable "region" {
    description = "Used to specify AWS region"
    type = string
    default = "eu-west-1"
}

variable "name" {
    description = "Used to name the bucket, this value is required"
    type = string
    default = "aaa.test-bucket.njofra.com"
}

variable "logging" {
    description = "Used to enable/disable logging on created bucket, bucket parameters must be defined"
    type = map(string)
    default = {log_bucket_id = "aaa.regular-bucket.njofra.com"
               log_bucket_prefix = "aaa.test-bucket.njofra.com_logs/"}
}

variable "life_cycle" {
    description = "Used to enable/disable lifecycling on created bucket"
    type = map(string)
    default = {days = 180}
}

variable "replication" {
    description = "Used to enable/disable replication on created bucket, replication policy must be defined"
    type = map(string)
    default = {replication_role_name = "my_replication_role1337"
               replication_policy_name = "my_replication_policy1337"
               replication_bucket_arn = "arn:aws:s3:::aaa.regular-bucket.njofra.com"}
}

variable "versioning" {
    description = "Used to enable/disable versioning on created bucket"
    type = map(string)
    default = {
        enabled = "true"
    }
}

variable "encryption" {
    description = "Used to enable/disable encryption on created bucket."
    type = map(string)
    default = {
        key_duration = 7
    }
}

variable "iamuser" {
    description = "Used to create an IAM user with full R/W permissions on created bucket"
    type = bool
    default = true
}