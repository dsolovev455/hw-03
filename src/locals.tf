#locals{
#    vms_metadata = {
#      serial-port-enable = 1
#      ssh-keys  = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIk1IXFg5e0XiyXLmnlsdaynRlCK4b3bY+slqvmiDQlE sasha047@mail.ru"
#    }
#}

locals{
    vms_metadata = {
      serial-port-enable = 1
      ssh-keys  = "ubuntu:${file("~/.ssh/id_ed25519.pub")} " 
    }
}
