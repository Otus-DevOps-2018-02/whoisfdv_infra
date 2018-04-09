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