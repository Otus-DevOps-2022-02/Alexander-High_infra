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

6. Практика управления ресурсами Yandex.Cloud через yc

Данные для подключения:
testapp_IP = 51.250.75.173
testapp_port = 9292

Код запуска инстанса:
yc compute instance create \
	--name reddit-app \
	--hostname reddit-app \
	--memory=4 \
	--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
	--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
	--metadata serial-port-enable=0 \
	--metadata-from-file user-data=./metadata.yaml

Установка Ruby, Bundler, MongoDB и Git (необходим для загрузки кода приложения) прописана в metadata.yaml
Выполнение всех шагов знаменуется выводом в порт сообщения "All Right Man !!!"
[   89.816122] cloud-init[743]: Cloud-init v. 21.1-19-gbad84ad4-0ubuntu1~16.04.2 running 'modules:final' at Sat, 13 Aug 2022 18:24:48 +0000. Up 9.09 seconds.
[   89.816620] cloud-init[743]: All Right Man !!!

*вариативно все команды можно было собрать в один исполняемый скрипт .sh (х) и прописать в metadata вызов это скрипта через bash.

**При запуске апвтоматических тестов выявлена ошибка в отсутствии на тестовом образе информации и сертификатов для работы с протоколом https:
E: The method driver /usr/lib/apt/methods/https could not be found" при выполнении apt update
Для устранения ошибки в скрипт install_mongodb.sh внесена строка для установки необходимых сертификатов:
sudo apt -y install apt-transport-https ca-certificates

7. Сборка образов VM при помощи Packer

Создан шаблон ubuntu16.json для настройки хоста с предустановленными MongoDB И Ruby.
Поведена параметризация шаблона ubuntu16.json переменными yc_folder_id, yc_sa_key_file, yc_subnet_id.
Внесены дополнительные опции указатель зоны и объем диска.

Build 'yandex' finished after 4 minutes 1 second.

==> Wait completed after 4 minutes 1 second

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: reddit-base-1661007050 (id: fd8n9rbc8fsv1e0g37jm) with family name reddit-base

8. Декларативное описание в виде кода инфраструктуры YC, требуемой для запуска тестового приложения, при помощи Terraform.

input переменная для приватного ключа, использующегося в определении подключения для провижинеров (connection):
variable "public_key_path"

Определите input переменную для задания зоны в ресурсе "yandex_compute_instance" "app". У нее должно быть значение по умолчанию:
variable "zone"
default = "ru-central1-a"

Отформатированы все конфигурационные файлы используя команду terraform fmt (с ключами -check -diff)
➜  terraform git:(terraform-1) ✗ terraform fmt
main.tf
outputs.tf
terraform.tfvars
variables.tf
