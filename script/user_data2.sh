#!/bin/bash
# Atualiza os pacotes do sistema
apt update -y && apt upgrade -y

# Instala pacotes necessários
apt install -y docker.io docker-compose awscli nfs-common

# Adiciona o usuário ubuntu ao grupo docker para evitar precisar de sudo
usermod -aG docker ubuntu

# Habilita e inicia o serviço do Docker
systemctl enable docker
systemctl start docker

# Cria o diretório para o projeto
mkdir -p /home/ubuntu/wordpress
cd /home/ubuntu/wordpress

# Cria o arquivo docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.1'

services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: compass.cfayu2u66e7w.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: diogo
      WORDPRESS_DB_PASSWORD: senha123
      WORDPRESS_DB_NAME: compass
    volumes:
      - wordpress_data:/var/www/html
      - /mnt/efs:/var/www/html/wp-content

volumes:
  wordpress_data:
EOF

# Montagem do EFS
mkdir -p /mnt/efs
echo "fs-0d15695ffb195969b.efs.us-east-1.amazonaws.com:/ /mnt/efs nfs4 defaults,_netdev 0 0" >> /etc/fstab
mount -a

# Sobe os containers do WordPress
docker-compose up -d

# Permissões
chown -R ubuntu:ubuntu /home/ubuntu/wordpress
