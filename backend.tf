terraform {
  backend "s3" {
    bucket         = "paula-bucket-for-statfile"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    profile        = "paula"
    dynamodb_table = "paula-statelock"
  }
}
