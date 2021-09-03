resource "google_compute_network" "demo_vpc_network" {
  name                    = "demo-vpc-network"
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "demo_subnet" {
  name          = "demo-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.demo_vpc_network.id
  project       = var.project_id
  region        = "europe-west1"
}

resource "google_compute_firewall" "demo_rule" {
  name    = "test-firewall"
  network = google_compute_network.demo_vpc_network.name
  project = var.project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  target_tags = ["demo"]
}