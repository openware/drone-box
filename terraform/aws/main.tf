provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "random_id" "main" {
  byte_length = 2
}

resource "aws_key_pair" "main" {
  key_name   = "${var.instance_name}-${random_id.main.hex}"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "main" {
  ami           = var.source_ami
  instance_type = var.instance_type

  key_name = aws_key_pair.main.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.main.id]

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  provisioner "local-exec" {
    command = "mkdir -p /tmp/upload && rsync -rv --exclude=terraform* . /tmp/upload/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo useradd -g users -s `which bash` -m deploy",
      "mkdir -p /home/${var.ssh_user}/platform",
      "sudo mkdir -p /home/deploy/platform",
    ]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key_path)
    }
  }

  provisioner "file" {
    source      = "/tmp/upload/"
    destination = "/home/${var.ssh_user}/platform"

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/${var.ssh_user}/platform /home/deploy/platform",
      "sudo chown -R deploy: /home/deploy/platform"
    ]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key_path)
    }
  }

  provisioner "remote-exec" {
    script = "bin/install.sh"

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key_path)
    }
  }
}

