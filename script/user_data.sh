#!/bin/bash
# Atualizando pacotes e instalando dependências
apt update && apt upgrade -y
apt install -y nfs-common docker.io docker-compose

# Habilitando e iniciando o Docker
systemctl enable docker
systemctl start docker

# Criando diretório para montar o EFS
mkdir -p /mnt/efs
mount -t nfs4 <EFS-ENDPOINT>:/ /mnt/efs

# Criando diretório para o projeto e movendo para ele
mkdir -p /home/ubuntu/wordpress
cd /home/ubuntu/wordpress

# Criando o arquivo docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.3'
services:
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: senha_root
      MYSQL_DATABASE: wordpress
      MYSQL_USER: user
      MYSQL_PASSWORD: senha
    volumes:
      - db_data:/var/lib/mysql
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: user
      WORDPRESS_DB_PASSWORD: senha
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - /mnt/efs:/var/www/html
volumes:
  db_data:
EOF

# Iniciando os containers
docker-compose up -d
