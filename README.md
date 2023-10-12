# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

------

### Задание 1

1. Изучите проект.
2. Заполните файл personal.auto.tfvars.
3. Инициализируйте проект, выполните код. Он выполнится, даже если доступа к preview нет.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.

### Решение

1. Скопировал проект и изчил;
2. Скопировал файл файл personal.auto.tfvars с предыдущей задачи;
3. Результат выполнения проекта:
![Рис.1-1](img/%D0%A0%D0%B8%D1%81.1-1.png)  
![Рис.1-2](img/%D0%A0%D0%B8%D1%81.1-2.png)  
![Рис.1-3](img/%D0%A0%D0%B8%D1%81.1-3.png)  

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами,   
используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.  
(как это сделать узнайте в документации провайдера yandex/compute_instance )  
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ с именами "main" и "replica" **разных** по cpu/ram/disk , используя мета-аргумент **for_each loop**. 
Используйте для обеих ВМ одну общую переменную типа list(object({ vm_name=string, cpu=number, ram=number, disk=number  })).  
При желании внесите в переменную все возможные параметры.  
3. ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.
4. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
5. Инициализируйте проект, выполните код.

### Решение
1. 
![Рис.2-1](img/%D0%A0%D0%B8%D1%81.2-1.png)  
![Рис.2-2](img/%D0%A0%D0%B8%D1%81.2-2.png)  
![Рис.2-3](img/%D0%A0%D0%B8%D1%81.2-3.png)  
![Рис.2-4](img/%D0%A0%D0%B8%D1%81.2-4.png)  
2.
![Рис.2-7](img/%D0%A0%D0%B8%D1%81.2-7.png)  
3. 
```
зависиит от. Это значит, что пока не создатся web, db - не начнет создаваться
depends_on = [ yandex_compute_instance.web ]

```
4. Добавил local { ssh = ... }

5. Запуск проекта:   
![Рис.2-5](img/%D0%A0%D0%B8%D1%81.2-5.png)  
![Рис.2-6](img/%D0%A0%D0%B8%D1%81.2-6.png)  

- Также прочитал и выяснил, что можно немного оптимизировать код:  
```
Определить переменную

variable "instance_config" {
  description = "Configuration for Yandex Compute Instance"
  type        = map(object({
    name         = string
    zone         = string
    machine_type = string
    image        = string
  }))
  default     = {
    example_instance = {
      name         = "example-instance"
      zone         = "ru-central1-a"
      machine_type = "e2.micro"
      image        = "ubuntu-2004-lts"
    }
  }
}
Использовать переменную в ресурсе `yandex_compute_instance`

resource "yandex_compute_instance" "example" {
  count = length(var.instance_config)

  for_each = var.instance_config

  name         = each.value.name
  zone         = each.value.zone
  machine_type = each.value.machine_type
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.example.id
  }
}

создать несколько конфигураций, например:

module "instance1" {
  source = "example_module"
  instance_config = {
    example_instance1 = {
      name         = "instance1"
      zone         = "ru-central1-a"
      machine_type = "e2.micro"
      image        = "ubuntu-2004-lts"
    }
  }
}

module "instance2" {
  source = "example_module"
  instance_config = {
    example_instance2 = {
      name         = "instance2"
      zone         = "ru-central1-b"
      machine_type = "e2.small"
      image        = "debian-10"
    }
  }
}


Что позволит использовать один `yandex_compute_instance`
 ресурс с разными конфигурациями, указанными в переменной `instance_config`
```
------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

### Решение:
1. Создал файл и добавил конфигурацию; 
![Рис.3-1](img/%D0%A0%D0%B8%D1%81.3-1.png)  

2. Результат выполнения:  
![Рис.3-2](img/%D0%A0%D0%B8%D1%81.3-2.png)  

------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demonstration2).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы [webservers], [databases], [storage] и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
4. Выполните код. Приложите скриншот получившегося файла. 

### Решение:
- добавил файлы;  
- отредактировал конфигурацию;  
- выполнил команду **terraform init -upgrade**;  
- Запустил код  
![Рис.4-1](img/%D0%A0%D0%B8%D1%81.4-1.png)  

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 5* (необязательное)
1. Напишите output, который отобразит все 5 созданных ВМ в виде списка словарей:
``` 
[
 {
  "name" = 'имя ВМ1'
  "id"   = 'идентификатор ВМ1'
  "fqdn" = 'Внутренний FQDN ВМ1'
 },
 {
  "name" = 'имя ВМ2'
  "id"   = 'идентификатор ВМ2'
  "fqdn" = 'Внутренний FQDN ВМ2'
 },
 ....
]
```
Приложите скриншот вывода команды ```terrafrom output```.

------

### Задание 6* (необязательное)

1. Используя null_resource и local-exec, примените ansible-playbook к ВМ из ansible inventory-файла.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/demonstration2).
3. Дополните файл шаблон hosts.tftpl. 
Формат готового файла:
```netology-develop-platform-web-0   ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>"```

Для проверки работы уберите у ВМ внешние адреса. Этот вариант используется при работе через bastion-сервер.
Для зачёта предоставьте код вместе с основной частью задания.

### Использованые ресурсы:
[**Ссылка_1**](https://ikshitij.com/open-connection-authentication-agent).
[**Ссылка_2**](https://andrdi.com/blog/terraform-ansible-provisioner.html).
[**Ссылка_3**](https://habr.com/ru/companies/nixys/articles/721404/).
[**Ссылка_4**](https://sidmid.ru/%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0%D1%82%D1%8C-%D1%81-terraform-%D0%B2-yandex-%D0%BE%D0%B1%D0%BB%D0%B0%D0%BA%D0%B5/).



