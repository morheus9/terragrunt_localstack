include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/s3-bucket"
}

inputs = {
  bucket_name = "my-localstack-bucket"
}
