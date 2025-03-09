# 📌 Atividade AWS - Docker

## 📅 Prazo
- **Entrega**: 10/03/2025 (Enviar o link do repositório com código, versionamento e documentação no chat da Daily)
- **Apresentação**: 11/03/2025

## 📌 Objetivo
Esta atividade tem como objetivo fixar conhecimentos sobre **Docker e AWS**, implementando uma aplicação WordPress com:
- **EC2 com Docker** para hospedar a aplicação
- **RDS (MySQL)** como banco de dados
- **EFS** para armazenar arquivos estáticos
- **Load Balancer (LB)** para balanceamento de carga

## 📌 Requisitos
### ✅ Configuração do EC2 com Docker
1. Criar uma instância **EC2**
2. Instalar e configurar o **Docker** ou **Containerd**
3. Implementar a configuração via **script User Data** (`user_data.sh`)

### ✅ Deploy da aplicação WordPress
1. Criar um container para a aplicação
2. Criar um container para o banco de dados **MySQL no RDS**

### ✅ Configuração do **EFS (Elastic File System)**
1. Configurar o EFS para armazenar os arquivos estáticos do WordPress

### ✅ Configuração do **Load Balancer (LB)**
1. Configurar o **Load Balancer Classic** para distribuir tráfego
2. **Evitar utilizar IP público** para exposição do serviço

### ✅ Outros Pontos
- O WordPress deve estar acessível pela porta **80 ou 8080**
- Uso de **Dockerfile ou Docker Compose** fica a critério da equipe
- Versionamento do código no **GitHub**
- Criar documentação

## 📌 Configuração do Docker no EC2
Durante a criação da EC2, adicionar o seguinte **User Data**:

```bash
#!/bin/bash
apt update && apt upgrade -y
apt install -y nfs-common docker.io docker-compose
```

### 🔹 Montando o EFS
```bash
sudo mkdir -p /mnt/efs
sudo mount -t nfs4 <EFS-ENDPOINT>:/ /mnt/efs
```

## 📌 Arquivo `docker-compose.yml`

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

### 🔹 Deploy da Aplicação
```bash
docker-compose up -d
```

Agora, acesse `http://<IP-DA-EC2>` e complete a instalação do WordPress. 🚀

---

## 📌 Considerações Finais

📌 Certifique-se de que a aplicação está rodando corretamente e de que o Load Balancer está distribuindo o tráfego adequadamente. A entrega será avaliada com base na execução funcional e na estrutura da configuração. Boa sorte! 🚀

