terraform {
  backend "gcs" {
    bucket = "bucketname123"
    prefix = "terraform/state"
  }
}