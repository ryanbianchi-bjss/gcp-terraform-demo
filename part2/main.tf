resource "google_compute_instance" "demo_vm" {
  name         = "demo-vm"
  machine_type = "e2-micro"
  project      = var.project_id
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

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

resource "google_container_cluster" "demo_cluster" {
  name     = "my-demo-gke-cluster"
  location = "europe-west1-b"
  project  = var.project_id

  network    = google_compute_network.demo_vpc_network.id
  subnetwork = google_compute_subnetwork.demo_subnet.id

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }

  master_authorized_networks_config {
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.168.0.0/28"

    master_global_access_config {
      enabled = true
    }
  }

  networking_mode          = "VPC_NATIVE"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-demo-node-pool"
  location   = "europe-west1-b"
  cluster    = google_container_cluster.demo_cluster.name
  node_count = 1
  project    = var.project_id

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
  }
}