##  Variables used by Terraform S3 bucket deployment module:
##  - bucket name
##  - logging
##  - object lifecycle
##  - object replication
##  - versioning
##  - encryption
##  - option to create a dedicated IAM user with IAM policy for full r/w access on the created bucket(s)

#done
variable "name" {
    description = "Used to name the bucket, if ommited, AWS will generate a random name"
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
        enabled = true
        days = 180
    }
}

variable "replication" {
    description = "Used to enable/disable replication on created bucket, replication policy must be defined"
    type = any
    default = []
}
#done
variable "versioning" {
    description = "Used to enable/disable versioning on created bucket"
    type = map(string)
    default = {}
}
#done
variable "encryption" {
    description = "Used to enable/disable encryption on created bucket."
    type = map(string)
    default = {
        enabled = false
    }
}
#done
variable "iamuser" {
    description = "Used to create an IAM user with full R/W permissions on created bucket"
    type = bool
    default = false
}