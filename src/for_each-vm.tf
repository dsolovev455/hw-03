######
resource "yandex_compute_instance" "db" {

  depends_on = [ yandex_compute_instance.web ]

  for_each = { for vm in local.vms_bav: "${vm.vm_name}" => vm }
  name = each.key
  platform_id = "standard-v2"
  resources {
        cores           = each.value.cpu
        memory          = each.value.ram
        core_fraction = each.value.frac
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = local.ssh
  }
}

locals {
  vms_bav = [
        {
        vm_name = "main"
        cpu     = 4
        ram     = 4
        frac    = 20
        },
        {
        vm_name = "replica"
        cpu     = 2
        ram     = 2
        frac    = 5
        }
  ]
}

locals {
  ssh = "ubuntu:${var.vms_ssh_root_key}"
}
