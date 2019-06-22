#!/bin/bash

grep 'sysctl -p' /etc/rc.local



if [ $? -ne 0 ]
then

echo 'sysctl -p' >> /etc/rc.local

echo 'net.core.rmem_max = 304800000' >> /etc/sysctl.conf
echo 'net.core.rmem_default = 102400000' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 304800000' >> /etc/sysctl.conf
echo 'net.core.wmem_default = 102400000' >> /etc/sysctl.conf
echo 'net.ipv4.udp_mem = 8499228 11332306 16998456' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem = 8499228 11332306 16998456' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem = 8499228 11332306 16998456' >> /etc/sysctl.conf
echo 'net.ipv4.route.flush = 1' >> /etc/sysctl.conf
fi

sysctl -p

