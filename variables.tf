##  Variables used by Terraform S3 bucket deplyoment module:
##  - logging
##  - object lifecycle
##  - object replication
##  - versioning
##  - encryption
##  - option to create a dedicated IAM user with IAM policy for full r/w access on the created bucket(s)


variable "logging" {
    description = "Switch to enable/disable logging on created bucket"
    type = bool
    default = false
}

variable "lifecycle" {
    description = "Switch to enable/disable lifecycling on created bucket"
    type = bool
    default = false
}

variable "replication" {
    description = "Switch to enable/disable replication on created bucket"
    type = bool
    default = false
}

variable "versioning" {
    description = "Switch to enable/disable versioning on created bucket"
    type = bool
    default = false
}

variable "encryption" {
    description = "Switch to enable/disable encryption on created bucket."
    type = bool
    default = false
}

variable "iamuser" {
    description = "Switch to create an IAM user with full R/W permissions on created bucket"
    type = bool
    default = false
}