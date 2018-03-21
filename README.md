# whoisfdv_infra
whoisfdv Infra repository

# Hostwork 4 (GCP Bastion)

bastion_IP = 104.155.21.19 someinternalhost_IP = 10.132.0.3

Для подключения к someinternalhost одной командой, требуется настроить "Jumphost" через bastion.
Для этого требуется следующая конфигурация SSH:

```
$ cat ~/.ssh/config                                                                                                                                                                   ✔  934  21:34:19

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
