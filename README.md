# 🚀 Deploy de WordPress com Docker na AWS

Este guia descreve o processo de implantação de um ambiente WordPress na AWS utilizando Docker e Docker Compose. O setup inclui:

## 🔹 1. Configuração da AWS

### 🔸 VPC e Security Groups
1. Crie uma **VPC** personalizada.
2. Configure **subnets públicas e privadas**.
3. Defina **Security Groups** permitindo acesso HTTP/HTTPS (porta 80/443) e SSH (porta 22).

### 🔸 RDS (Banco de Dados MySQL)
1. Crie uma instância **RDS MySQL**.
2. Configure o **Security Group** para permitir conexões da EC2.
3. Anote o **endpoint do banco de dados**.

### 🔸 EFS (Armazenamento Compartilhado)
1. Crie um **EFS** para armazenar os arquivos do WordPress.
2. Configure as permissões de acesso.

### 🔸 EC2 e Load Balancer
1. Crie uma instância **EC2** com Ubuntu.
2. Configure um **Load Balancer** para distribuir o tráfego.

## 🔹 2. Configuração da EC2

### 🔸 User Data (Script de Inicialização)
Durante a criação da EC2, adicione o seguinte script em **User Data** para instalar pacotes essenciais:

```bash
#!/bin/bash
apt update && apt upgrade -y
apt install -y nfs-common docker.io docker-compose
```

### 🔸 Montando o EFS
Após acessar a EC2 via SSH, monte o EFS:
```bash
sudo mkdir -p /mnt/efs
sudo mount -t nfs4 <EFS-ENDPOINT>:/ /mnt/efs
```

## 🔹 3. Configuração do Docker Compose
Crie um arquivo `docker-compose.yml` com o seguinte conteúdo:

```yaml
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
```

Execute os comandos:
```bash
docker-compose up -d
```

Agora acesse `http://<IP-DA-EC2>` e complete a instalação do WordPress. 🚀

