resource "google_compute_firewall" "allow_web" {
  name    = "platform-firewall-${random_id.main.hex}"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-web"]
}

resource "google_compute_address" "main" {
  name = "platform-ip-${random_id.main.hex}"
}

resource "google_compute_network" "main" {
  name = "platform-network-${random_id.main.hex}"
}
