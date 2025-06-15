# Outputs for the Jenkins VM instances
output "jenkins_ips" {
  value = {
    for instance in google_compute_instance.jenkins_vm :
    instance.name => instance.network_interface[0].access_config[0].nat_ip
  }
}

