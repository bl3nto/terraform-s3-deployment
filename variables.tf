##  Variables used by Terraform S3 bucket deployment module:
##  - bucket name
##  - logging
##  - object lifecycle
##  - object replication
##  - versioning
##  - encryption
##  - option to create a dedicated IAM user with IAM policy for full r/w access on the created bucket(s)

#done
variable "credentials" {
    description = "Location of AWS credentials file used to access AWS API"
    type = string
    default = "./aws_credentials"
}
#done
variable "name" {
    description = "Used to name the bucket, if ommited, AWS will generate a random name"
    type = string
  #  default = null
}
#done
variable "logging" {
    description = "Used to enable/disable logging on created bucket"
    type = map(string)
    default = {}
}

variable "life_cycle" {
    description = "Used to enable/disable lifecycling on created bucket"
    type = any
    default = []
}

variable "replication" {
    description = "Used to enable/disable replication on created bucket"
    type = any
    default = {}
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
    type = any
    default = {}
}
#done
variable "iamuser" {
    description = "Used to create an IAM user with full R/W permissions on created bucket"
    type = bool
    default = false
}