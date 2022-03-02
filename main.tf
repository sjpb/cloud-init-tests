terraform {
  required_version = ">= 0.14"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  cloud = "openstack"
}

resource "openstack_compute_instance_v2" "test" {
  
  name = "sb-nfs-test"
  image_name = "RockyLinux-8.5-20211114.2"
  flavor_name = "vm.alaska.cpu.general.small"
  key_pair = "slurm-app-ci"
  security_groups = ["default"]
  user_data = file("${path.module}/nfs.yaml")

  network {
    name = "WCDC-iLab-60"
    access_network = true
  }

}

output "ip_addr" {
  value = [for n in openstack_compute_instance_v2.test.network: n.fixed_ip_v4 if n.access_network][0]
}
