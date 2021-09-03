terraform {
  required_version = "~> 1.0.5"

  required_providers {
    google = {
      version = "~> 3.81.0"
      source  = "hashicorp/google"
    }
  }
}