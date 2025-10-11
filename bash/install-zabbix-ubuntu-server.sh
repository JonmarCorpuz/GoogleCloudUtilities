#!/bin/bash

echo "Execute this script as root"

# Install Zabbix repository
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
apt update

# Install the Zabbix server, frontend, and agent
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# Create the initial database
mysql -uroot -p'password' <<EOF
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
EOF

# Import the intial schema and data
zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p password

# Disable the log_bin_trust_function_creators option after importing the database schema
mysql -uroot -p'password' <<EOF
set global log_bin_trust_function_creators = 0;
quit; 
EOF

# 
sed -i 's/^DBPassword=password$/DBPassword=password/' /etc/zabbix/zabbix_server.conf

#
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
