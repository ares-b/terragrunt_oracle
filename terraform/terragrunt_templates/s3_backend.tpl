
terraform {
  backend "s3" {
    access_key  = "${access_key}"
    secret_key  = "${secret_key}"
    bucket         = "${bucket}"
    key            = "${key}"
    region         = "${region}"
    encrypt        = true
  }
}
