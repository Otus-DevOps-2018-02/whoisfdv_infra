# whoisfdv_infra
whoisfdv Infra repository

## Homework 4 (GCP Bastion)

bastion_IP = 104.155.21.19

someinternalhost_IP = 10.132.0.3

Для подключения к someinternalhost одной командой, требуется настроить _Jumphost_ через bastion.
Для этого требуется следующая конфигурация SSH:

```
$ cat ~/.ssh/config                                                                                                         

Host bastion
  User appuser
  Hostname 104.155.21.19
  IdentityFile ~/.ssh/appuser

Host someinternalhost
  User appuser
  Hostname 10.132.0.3
  IdentityFile ~/.ssh/appuser
  Port 22
  ProxyCommand ssh -q -W %h:%p bastion
```

После чего для подключения достаточно команды: `ssh someinternalhost`

## Homework 5 (GCP testApp)

testapp_IP = 35.205.96.5

testapp_port = 9292

#### Самостоятельное задание

В рамках дополнительного задания был создан `startup_script.sh`, приводятся 3 варианта его использования и пример удаления/добавления правил firewall через gcloud.

###### --metadata-from-file startup-script=FILE

```
# gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=./startup_script.sh
```

###### --metadata-from-file startup-script=URL

Сначала вручную добавляем `gist` на стороне собственного GitHub аккаунта, для дальнейшего его использрвания по URL.

```
# gcloud compute instances create reddit-app\ 
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script='wget -O - https://gist.githubusercontent.com/whoisfdv/89927ca8e6b8f501dffa2b88c7f9e427/raw/a8073d049d48badb23e514dd06e81764563b3831/startup_script.sh | sudo bash'
```

###### --metadata-from-file startup-script=CONTENT

```
# gsutil mb gs://whoisfdv_infra
# gsutil cp startup_script.sh gs://whoisfdv_infra/ 

# gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata startup-script-url=gs://whoisfdv_infra/startup_script.sh
```

###### Удаляем/добавляем правила firewall через gcloud

```
# gcloud --quiet compute firewall-rules delete default-puma-server
# gcloud --quiet compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags puma-server
```

Проведено тестирование создания инстансов перечисленными способами. Создание\Удаление инстансов и правил производилось с помощью shell-утилиты `gcloud`.

## Homework 6 (Packer base)

#### Самостоятельные задания
 
 * В рамках самостоятельного задания некоторые параметры (_project_id_, _source_image_family_, _machine_type_) были вынесены в отдельный файл `variables.json`;
 * Добавлены дополнительные параметры (_image_description_, _disk_size_, _disk_type_, _network_, _tags_) GCP.
 
#### Задание со *
 
 * Создан дополнительный шаблон `immutable.json`;
 * Файлы службы `puma.service` размещены в директории `packer/files`;
 * В `config-scripts` создан скрипт `create-reddit-vm.sh` для создания инстанса из image'а _reddit-full_.

 ## Homework 7 (Terraform 1)

 #### Самостоятельные задания

  * Определена переменная _private_key_path_;
  * Определена переменна _zone_ с значением по умолчанию;
  * Создан шаблон конфига в файле `terraform.tfvars.example`.

## Homework 8 (Terraform 2)

#### Самостоятельные задания

 * Создане модули `app`, `db` и `vpc`
 * Созданы окружения `prod` и `stage` 

## Homework 9 (Ansible 1)

#### Самостоятельные задания

 * Созданны и проверенны базовые _inventory_-файлы и конфигурационный файл `ansible.cfg`
 * Создан и проверен плейбук `clone.yml`

 #### Задание со *

  * Написан простой _inventory_-скрипт для получения IP-адресов инстенсов окружения `stage` и генерации на основе полученной информации `inventory.json`

## Homework 10 (Ansible 2)

#### Самостоятельные задания

 * Изменены provision Packer'а с заменой bash-скриптов на ansible-playbook'и.
 * Выполнен билд новых образов, на основе которых запущено окружение `stage`, и проверенны деплой и работа приложения. 

 #### Задание со *

  * Произведена установка утилиты `terraform-inventory`
  * Изменен метод динамического получения inventory, на метод с использованием `terraform-inventory`
  * Для корректной работы утилиты, при исполнении плэйбуков ansible указываем путь до state-файла рабочего окружения:
  `TF_STATE=../terraform/stage/terraform.tfstate ansible-playbook site.yml` 

## Homework 11 (Ansible 3)

#### Самостоятельные задания

 * Произведена организация плэйбуков
 * Описаны роли `app` и `db` + добавлена роль `jdauphant.nginx` 
 * Описаны окружения `ansible/environments/prod` и `ansible/environments/stage`
 * Путем добавления тега `http-server` в описание конфигурации терраформа, добалено открытие 80 порта дли инстанса приложения
 * Добавлен вызов роли `jdauphant.nginx` в плейбуке `app.yml` 
 * Проверена работа плэйбука `site.yml` для окружения `stage`, включая доступность приложения по 80 порту

 #### Задание со *

  * Настроено использование динамического inventory для описанных окружений `ansible/environments/stage` и `ansible/environments/prod`. Работа организованна через созданный в ДЗ №9 sh-скрипт `inventory.sh`.
