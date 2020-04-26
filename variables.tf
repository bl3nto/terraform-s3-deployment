##  Variables used by Terraform S3 bucket deployment module:
##  - bucket name
##  - logging
##  - object lifecycle
##  - object replication
##  - versioning
##  - encryption
##  - option to create a dedicated IAM user with IAM policy for full r/w access on the created bucket(s)

#done
variable "region" {
    description = "Used to specify AWS region"
    type = string
    default = "eu-west-1"
}
#done
variable "name" {
    description = "Used to name the bucket, this value is required"
    type = string
    default = "test-bucket3222312.testing.example.com"
}
#done
variable "logging" {
    description = "Used to enable/disable logging on created bucket, bucket parameters must be defined"
    type = map(string)
    default = {}
}
#done
variable "life_cycle" {
    description = "Used to enable/disable lifecycling on created bucket"
    type = map(string)
    default = {
        enabled = false
        days = 180
    }
}

#done
variable "replication" {
    description = "Used to enable/disable replication on created bucket, replication policy must be defined"
    type = map(string)
    default = {
        replication_role_name = "my_replication_role"
        replication_policy_name = "my_replication_policy"
        replication_bucket_arn = "arn:aws:s3:::my-replication-bucket"
    }
}
#done
variable "versioning" {
    description = "Used to enable/disable versioning on created bucket"
    type = map(string)
    default = {}
}

variable "encryption" {
    description = "Used to enable/disable encryption on created bucket."
    type = map(string)
    default = {
        key_duration = 10
    }
}
#done
variable "iamuser" {
    description = "Used to create an IAM user with full R/W permissions on created bucket"
    type = bool
    default = true
}