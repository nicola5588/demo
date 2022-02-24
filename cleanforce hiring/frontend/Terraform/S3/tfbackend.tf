terraform {
  backend "s3" {
    bucket = "cleanforce-frontend-state"
    key    = "terraformstate/key"
    region = "ap-southeast-2"
  }
}