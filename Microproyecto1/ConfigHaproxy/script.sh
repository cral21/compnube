#!/bin/bash
echo "CONFIGURANDO HAPROXY LOAD BALANCER"

echo "INSTALACIÓN DE RECURSOS"
sudo apt install -y vim net-tools lxd

echo "CREANDO NUEVO GRUPO"
sudo newgrp lxd

echo "INICIANDO LXD"
sudo lxd init --auto

echo "LANZAR CONTENEDOR HAPROXY"
sudo lxc launch ubuntu:20.04 haproxy

echo "Iniciando el haproxy"
lxc start haproxy

echo "ACTUALIZAR CONTENEDOR HAPROXY"
sudo lxc exec haproxy -- sudo apt-get update && apt-get upgrade -y

echo "INSTALAR HAPROXY"
sudo lxc exec haproxy -- sudo apt install -y haproxy

echo "ACTIVAR HAPROXY"
sudo lxc exec haproxy -- sudo systemctl enable haproxy

sudo lxc exec haproxy -- sudo systemctl status haproxy

echo "SUBIENDO ARCHIVO DE CONFIGURACIÓN"
sudo lxc file push /vagrant/ConfigHaproxy/haproxy.cfg haproxy/etc/haproxy/

echo "RESTABLECIENDO HAPROXY"
sudo lxc exec haproxy -- sudo systemctl restart haproxy

echo "REDIRECCIONAMIENTO DE PUERTOS"
sudo lxc config device add haproxy myport80 proxy listen=tcp:192.168.100.4:80 connect=tcp:127.0.0.1:80

echo "SUBIENDO CONFIGURACIÓN PAGINA CAIDA"
sudo sudo lxc file push /vagrant/ConfigHaproxy/503.http haproxy/etc/haproxy/errors/

echo "SERVICIO LISTO"
sudo lxc exec haproxy -- sudo systemctl restart haproxy


