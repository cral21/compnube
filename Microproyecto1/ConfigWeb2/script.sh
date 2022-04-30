#!/bin/bash
echo "INSTALANDO PAQUETES NECESARIOS"
sudo apt install -y vim net-tools lxd

echo "CREANDO GRUPO LXD"
newgrp lxd

echo "INICIALIZANDO EL LXD "
lxd init --auto

echo "CREANDO CONTENEDOR WEB2"
lxc launch ubuntu:20.04 web2 --target web2

echo "Iniciar web2"
lxc start web2

echo "ACTUALIZANDO CONTENEDOR WEB2"
lxc exec web2 -- sudo apt update && apt upgrade -y

echo "INSTALANDO APACHE2"
lxc exec web2 -- apt install -y apache2
lxc exec web2 -- systemctl enable apache2

echo "GENERANDO ARCHIVO INDEX.HTML"
lxc file push /vagrant/ConfigWeb2/index.html web2/var/www/html/index.html

echo "CONFIGURANDO SERVICIO"
lxc exec web2 -- systemctl restart apache2

echo "REDIRECCIONAMIENTO DE PUERTOS"
lxc config device add web2 puertoo80 proxy listen=tcp:192.168.100.6:80 connect=tcp:127.0.0.1:80

echo "CREANDO CONTENEDOR BACKUP Web2"
lxc launch ubuntu:20.04 web2b --target web2

echo "Iniciar web2b"
lxc start web2b

echo "ACTUALIZANDO WEB2"
lxc exec web2b -- sudo apt update && apt upgrade -y

echo "INSTALANDO APACHE"
lxc exec web2b -- apt install -y apache2
lxc exec web2b -- systemctl enable apache2

echo "GENERANDO ARCHIVO INDEX.HTML"
lxc file push /vagrant/ConfigWeb2/index.html web2b/var/www/html/index.html

echo "CONFIGURANDO SERVICIO"
lxc exec web2b -- systemctl restart apache2

echo "REDIRECCIONAMIENTO DE PUERTOS"
lxc config device add web2b puertoo80 proxy listen=tcp:192.168.100.6:1080 connect=tcp:127.0.0.1:80

echo "SERVICIO LISTO"


