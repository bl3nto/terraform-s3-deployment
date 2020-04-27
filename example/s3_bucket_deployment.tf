## Terrafom S3 bucket deployment module
module "s3_bucket_deployment" {
      source      = "../../terraform-s3-deployment"

      name        = "my-test-bucket"
      region      = "eu-west-1"

##  Following data is optional, values below are an example:
   
      logging     = { log_bucket_id = "my-log-bucket"
                      log_bucket_prefix = "my-test-bucket_logs/"
                    }
      life_cycle  = { days = 180
                    }
      replication = { replication_role_name = "my-log-bucket_replication_role"
                      replication_policy_name = "my-log-bucket_replication_policy"
                      replication_bucket_arn = "arn:aws:s3:::my-replication-bucket"
                    }
      versioning  = { enabled = "true"
                    }
      encryption  = { key_duration = 10
                    }
      iamuser     = true

}