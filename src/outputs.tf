## web ##

output "web" {
  description = "Information about the instance web"
  value       = [
    for instance in yandex_compute_instance.web: {
    name = instance.name
    id   = instance.id
    fqdn = instance.fqdn
    }
  ]
}

## db ##

output "db" {
  description = "Information about the instance db"
  value = {
    for vm in local.vms_bav : vm["vm_name"] => {
      name  = yandex_compute_instance.db[vm["vm_name"]]["name"]
      fqdn  = yandex_compute_instance.db[vm["vm_name"]]["fqdn"]
      id    = yandex_compute_instance.db[vm["vm_name"]]["id"]
    }
  }
}

## storage ##

output "storage" {
  description = "Information about the instance storage"
  value = {
    name = yandex_compute_instance.storage[*].name
    id   = yandex_compute_instance.storage[*].id
    fqdn = yandex_compute_instance.storage[*].fqdn
  }
}

### VM WEB ###
#output "web_name" {
#  description = "name of this instance"
#  value       = yandex_compute_instance.web.*.name
#}

#output "web_id" {
#  description = "id of this instance"
#  value       = yandex_compute_instance.web.*.id
#}
#output "web_fqdn" {
#  description = "fqdn of this instance"
#  value       = yandex_compute_instance.web.*.fqdn
#}


### VM DB from for_each###

#output "db_name" {
#  description = " from for_each"
#  value = {
#    for vm in local.vms_bav :
#    vm["vm_name"] => yandex_compute_instance.db[vm["vm_name"]]["name"]
#  }
#}
#output "db_fqdn" {
#  description = " from for_each"
#  value = {
#    for vm in local.vms_bav :
#    vm["vm_name"] => yandex_compute_instance.db[vm["vm_name"]]["fqdn"]
#  }
#}
#output "db_id" {
#  description = " from for_each"
#  value = {
#    for vm in local.vms_bav :
#    vm["vm_name"] => yandex_compute_instance.db[vm["vm_name"]]["id"]
#  }
#}


### VM STORAGE ###

#output "storage_name" {
#  description = "name of this instance"
#  value       = yandex_compute_instance.storage.*.name
#}

#output "storage_id" {
#  description = "id of this instance"
#  value       = yandex_compute_instance.storage.*.id
#}

#output "storage_fqdn" {
#  description = "fqdn of this instance"
#  value       = yandex_compute_instance.storage.*.fqdn
#}

#output "storage" {
#  description = "List of storage instances"
#  value = [
#    for intance in yandex_compute_instance.storage : {
#    name = storage.name
#    id   = storage.id
#    fqdn = storage.fqdn
#    }
#  ]
#}


