terraform {
  backend "s3" {
    bucket = "fa-ci-platform-terraform"
    key    = "fa-ci-platform.tfstate"
    region = "eu-west-1"
  }
}
