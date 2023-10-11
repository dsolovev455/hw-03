resource "local_file" "inventory_cfg" {
  content = templatefile("${path.module}/inventory.tftpl",
    { 
    web =  yandex_compute_instance.web,
    db =  yandex_compute_instance.db, 
    storage =  [yandex_compute_instance.storage]   
    }  
)

  filename = "${abspath(path.module)}/inventory"
}


resource "null_resource" "web_hosts_provision" {
#Ждем создания инстанса
depends_on = [yandex_compute_instance.storage, local_file.inventory_cfg]

#Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
#    command = "cat ~/.ssh/id_ed25519 | ssh-add -"
    command = "cat ~/.ssh/id_ed25519 | ssh-add -"
  }

#Костыль!!! Даем ВМ 60 сек на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
# В случае использования cloud-init может потребоваться еще больше времени
 provisioner "local-exec" {
    command = "sleep 60"
  }

#Запуск ansible-playbook
  provisioner "local-exec" {                  
    command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/test.yml"
    on_failure = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
    triggers = {  
#всегда т.к. дата и время постоянно изменяются
      always_run         = "${timestamp()}" 
 # при изменении содержимого playbook файла
      playbook_src_hash  = file("${abspath(path.module)}/test.yml") 
      ssh_public_key     = var.vms_ssh_root_key # при изменении переменной
    }

}
