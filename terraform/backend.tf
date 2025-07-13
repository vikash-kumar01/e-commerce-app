terraform {
  backend "s3" {
    bucket = "cloudwithvikash-terraform-backend"
    key    = "backend-locking"
    region = "us-east-1"
    use_lockfile = true
  }
}