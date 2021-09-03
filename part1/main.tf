resource "google_project" "demo_project" {
  billing_account = var.billing_account
  name            = var.project_id
  project_id      = var.project_id
}

resource "google_service_account" "demo_service_account" {
  account_id   = "demo-terraform"
  display_name = "Service Account for Terraform demo"
  project      = google_project.demo_project.name
}

resource "google_project_iam_member" "demo_service_account_iam" {
  project = google_project.demo_project.name
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.demo_service_account.email}"
}

resource "google_storage_bucket" "demo_state_bucket" {
  name          = var.bucket_name
  location      = "EU"
  force_destroy = true
  project       = google_project.demo_project.name

  versioning {
    enabled = true
  }
}

resource "google_project_service" "service_usage_api" {
  project = google_project.demo_project.name
  service = "serviceusage.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "compute_api" {
  project = google_project.demo_project.name
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "kubernetes_api" {
  project = google_project.demo_project.name
  service = "container.googleapis.com"

  disable_dependent_services = true
}