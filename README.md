# Alexander-High_infra
Alexander-High Infra repository
5. Знакомство с облачной инфраструктурой

Для подключения к серверу someinternalhost используем включенный ранее ssh forwarding, и используем вход по команде:

ssh -i ~/.ssh/ya_key -A  appuser@51.250.73.59 ssh appuser@10.128.0.31
где,
ya_key — имя ssh ключа авторизации,

ssh forwarding пробрасывает данные авторизации по ключу ssh через сервер bastion на сервер  someinternalhost

Дополнительное задание

Для создания alias для входа на сервер someinternalhost с локальной машины необходимо создать файл ~/.ssh/config
В файл внести данные для авторизации на сервере someinternalhost  и использовать создание виртуального тунеля через сервер bastion. Ниже приведен config файл:

Host someintrnalhost
HostName 10.128.0.31
User appuser
IdentityFIle ~/.ssh/ya_key
ProxyCommand ssh appuser@51.250.9.173 nc %h %p

Host bastion
HostName 51.250.9.173
User appuser
IdentityFile ~/.ssh/ya_key

В файл так же внесен alias для входа на сервер bastion

      Адреса хостов:
bastion_IP = 51.250.9.173
someinternalhost_IP = 10.128.0.31


Использование валидного сертификата:
Через WEB-интервейс pritunl в разделе settings в поле Let's Encrypt необходимо вставить строку вида:

51.250.9.173.sslip.io
