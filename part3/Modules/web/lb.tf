resource "google_compute_http_health_check" "demo_lb_health_check" {
  name         = "demo-lb-health-check"
  project      = var.project_id
  request_path = "/"

  timeout_sec        = 5
  check_interval_sec = 30
}

resource "google_compute_backend_service" "demo_backend" {
  name          = "demo-backend-service"
  health_checks = [google_compute_http_health_check.demo_lb_health_check.id]
  project       = var.project_id

  backend {
    group = google_compute_instance_group_manager.demo_mig.instance_group
  }
}

resource "google_compute_url_map" "demo_urlmap" {
  name    = "demo-urlmap"
  project = var.project_id

  default_service = google_compute_backend_service.demo_backend.id
}

resource "google_compute_target_http_proxy" "demo_http_proxy" {
  name    = "demo-proxy"
  project = var.project_id
  url_map = google_compute_url_map.demo_urlmap.id
}

resource "google_compute_global_forwarding_rule" "demo_forwarding" {
  name       = "demo-rule"
  project    = var.project_id
  target     = google_compute_target_http_proxy.demo_http_proxy.id
  port_range = "80"
}