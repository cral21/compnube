#!/bin/bash
echo "INSTALANDO PAQUETES NECESARIOS"
sudo apt install -y vim net-tools lxd

echo "CREANDO GRUPO LXD"
newgrp lxd

echo "INICIALIZANDO EL LXD "
lxd init --auto

echo "CREANDO CONTENEDOR WEB1"
lxc launch ubuntu:20.04 web1 --target web1

echo "Iniciar web"
lxc start web1

echo "ACTUALIZANDO CONTENEDOR"
lxc exec web1 -- sudo apt update && apt upgrade -y

echo "INSTALANDO APACHE2"
lxc exec web1 -- apt install -y apache2
lxc exec web1 -- systemctl enable apache2

echo "GENERANDO ARCHIVO INDEX.HTML"
lxc file push /vagrant/ConfigWeb1/index.html web1/var/www/html/index.html

echo "CONFIGURANDO SERVICIO"
lxc exec web1 -- systemctl restart apache2

echo "REDIRECCIONAMIENTO DE PUERTOS"
lxc config device add web1 puerto80 proxy listen=tcp:192.168.100.5:80 connect=tcp:127.0.0.1:80

echo "CONTENEDOR BACKUP web1"
lxc launch ubuntu:20.04 web1b --target web1

echo "Iniciar web"b
lxc start web1b

echo "ACTUALIZANDO BACKUP"
lxc exec web1b -- sudo apt update && apt upgrade -y

echo "INSTALANDO APACHE2"
lxc exec web1b -- apt install -y apache2
lxc exec web1b -- systemctl enable apache2

echo "GENERANDO ARCHIVO INDEX.HTML"
lxc file push /vagrant/ConfigWeb1/index.html web1b/var/www/html/index.html

echo "CONFIGURANDO SERVICIO CONTENEDOR"
lxc exec web1b -- systemctl restart apache2

echo "REDIRECCIONAMIENTO DE PUERTOS"
lxc config device add web1b puerto80 proxy listen=tcp:192.168.100.5:1080 connect=tcp:127.0.0.1:80

echo "SERVICIO LISTO"


