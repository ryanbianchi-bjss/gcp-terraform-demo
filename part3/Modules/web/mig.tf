resource "google_compute_instance_template" "demo_template" {
  name        = "demo-template"
  description = "This template is used to demo VM instances."
  project     = var.project_id

  tags = ["demo"]

  instance_description = "description assigned to instances"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "bjss-demo-project-lb2508/bjss-demo-image"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.demo_vpc_network.id
    subnetwork = google_compute_subnetwork.demo_subnet.id
  }
}

resource "google_compute_health_check" "demo_health_check" {
  name               = "demo-health-check"
  project            = var.project_id
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "22"
  }
}

resource "google_compute_instance_group_manager" "demo_mig" {
  name = "demo-mig"

  base_instance_name = "demo"
  project            = var.project_id
  zone               = "europe-west1-b"

  version {
    instance_template = google_compute_instance_template.demo_template.id
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.demo_health_check.id
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "default" {
  name    = "my-demo-autoscaler"
  project = var.project_id
  zone    = "europe-west1-b"
  target  = google_compute_instance_group_manager.demo_mig.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60
  }
}