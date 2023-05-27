# ---------------------------------------------------------------------------------------------------------------------
# Create an instance with OS Login configured to use as a bastion host.
# ---------------------------------------------------------------------------------------------------------------------

// Allow access to the Bastion Host via SSH.
resource "google_compute_firewall" "bastion-ssh" {
  name          = "allow-bastion-ssh"
  network       = var.network
  direction     = "INGRESS"
  project       = var.project
  source_ranges = var.source_ranges

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["bastion"]
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install -y tinyproxy
  EOF
}

resource "google_compute_instance" "bastion_host" {
  project      = var.project
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = [var.tag]

  boot_disk {
    initialize_params {
      image = var.source_image
    }
  }

  network_interface {
    subnetwork = var.subnetwork

    // If var.static_ip is set use that IP, otherwise this will generate an ephemeral IP
    access_config {
      nat_ip       = var.static_ip
      network_tier = "STANDARD"
    }
  }

  metadata_startup_script = data.template_file.startup_script.rendered

  metadata = {
    enable-oslogin = "TRUE"
  }
}
