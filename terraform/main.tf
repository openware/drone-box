provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

provider "random" {
}

resource "random_id" "main" {
  byte_length = 2
}

resource "google_compute_instance" "main" {
  name         = "${var.instance_name}-${random_id.main.hex}"
  machine_type = var.machine_type
  zone         = var.zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.image
      type  = "pd-ssd"
      size  = var.disk_size
    }
  }

  network_interface {
    network = google_compute_network.main.name

    access_config {
      nat_ip = google_compute_address.main.address
    }
  }

  service_account {
    scopes = ["storage-ro"]
  }

  tags = ["allow-web"]

  metadata = {
    sshKeys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }

  provisioner "local-exec" {
    command = "mkdir -p /tmp/upload && rsync -rv --exclude=terraform* . /tmp/upload/"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.ssh_user}/platform",
    ]

    connection {
      host        = self.network_interface[0].access_config[0].nat_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
    }
  }

  provisioner "file" {
    source      = "/tmp/upload/"
    destination = "/home/${var.ssh_user}/platform"

    connection {
      host        = self.network_interface[0].access_config[0].nat_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
    }
  }

  provisioner "remote-exec" {
    script = "bin/install.sh"

    connection {
      host        = self.network_interface[0].access_config[0].nat_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
    }
  }
}
