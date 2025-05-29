# Create a ssh keypair, combination of public and private key
resource "tls_private_key" "i27-ecommerce-key" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

# Save the private key to local file 
resource "local_file" "i27-ecommerce-key-private" {
  content = tls_private_key.i27-ecommerce-key.private_key_pem
  filename = "${path.module}/id_rsa"
}

# Save the Public key to local file 
resource "local_file" "i27-ecommerce-key-public" {
  content = tls_private_key.i27-ecommerce-key.public_key_openssh
  filename = "${path.module}/id_rsa.pub"
}

# ssh-keygen 
# Create Multiple Google Compute Instance
resource "google_compute_instance" "tf-vm-instance" {
    for_each = var.instances
    # set of strings , eack.key = each.value
    # map of strigns , each.key and each.value
  name = each.key 
  machine_type =  each.value.instance_type
  zone = each.value.zone
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20250424"
      size = each.value.disk_size
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = each.value.subnet
    access_config {
      // Ephemeral ip
    }
  }
  metadata = {
    ssh-keys = "${var.vm_user}:${tls_private_key.i27-ecommerce-key.public_key_openssh}"
  }

  connection {
    host = self.network_interface[0].access_config[0].nat_ip
    type = "ssh" # "winrm"
    user = var.vm_user
    private_key = tls_private_key.i27-ecommerce-key.private_key_pem
    #password = 
  }

  # Provisioner : file 
  provisioner "file" {
    source =  each.key == "ansible" ? "ansible.sh" : "empty.sh"     #"ansible.sh"
    destination = each.key == "ansible" ? "/home/${var.vm_user}/ansible.sh" : "/home/${var.vm_user}/empty.sh"
  }


  # File provisioner to copy private key to all the vms
  # Place the private key inside vm
  provisioner "file" {
    source = "${path.module}/id_rsa"
    destination = "/home/${var.vm_user}/ssh-key"
  }


  # Provisioner block ro exeucte on the remote machine
  provisioner "remote-exec" {
    inline = [ 
      each.key == "ansible" ? "chmod +x /home/${var.vm_user}/ansible.sh && /home/${var.vm_user}/ansible.sh" : "echo 'Not an anbile vm'"
     ]
  }
}

# ssh -i private-key username@hostname
