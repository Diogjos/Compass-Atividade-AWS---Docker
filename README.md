# 🚀 Deploy de WordPress com Docker na AWS

Este guia descreve o processo de implantação de um ambiente **WordPress** na **AWS** utilizando **Docker e Docker Compose**. O setup inclui:

✅ Instância **EC2** com **Docker** rodando o WordPress  
✅ Banco de Dados **RDS MySQL**  
✅ Armazenamento compartilhado **EFS**  
✅ **Load Balancer** para distribuir tráfego  
✅ **Segurança com Security Groups**  

---

## 📌 1. Configuração da AWS  

### 🔹 Criando a VPC e Subnets  
1. Acesse o **AWS VPC Dashboard** e crie uma **VPC personalizada**.  
2. Adicione **duas subnets**:  
   - **Pública** para a instância EC2 e Load Balancer.  
   - **Privada** para o banco de dados RDS.  
3. Crie um **Internet Gateway** e vincule à VPC.  
4. Configure a **tabela de rotas** para permitir o tráfego externo na subnet pública.  

### 🔹 Criando Security Groups  
1. **Security Group para EC2**  
   - Permitir **porta 22 (SSH)** apenas para seu IP.  
   - Permitir **porta 80 e 443** para acesso web.  
2. **Security Group para RDS**  
   - Permitir conexão apenas da **EC2** na porta **3306**.  

---
## 📌 2. Configuração do Banco de Dados RDS  
1. Vá para **RDS Dashboard** e clique em **Create Database**.  
2. Escolha **MySQL**, versão **5.7**.  
3. Defina as credenciais de acesso:  
   - **Usuário**: `user`  
   - **Senha**: `senha`  
4. Coloque a instância na **subnet privada** da VPC.  
5. Configure o **Security Group** para permitir acesso apenas da **EC2**.  

---

## 📌 3. Criando o EFS para Armazenamento Compartilhado  
1. Acesse o **EFS Dashboard** e clique em **Create File System**.  
2. Escolha a **mesma VPC da EC2** e **subnets públicas**.  
3. Configure permissões para a EC2 acessar o EFS.  
4. Pegue o **endpoint do EFS** e adicione no script de User Data da EC2.  

---
## 📌 4. Criando a Instância EC2  
1. Acesse o **EC2 Dashboard** e clique em **Launch Instance**.  
2. Escolha a **imagem Ubuntu 22.04 LTS**.  
3. Selecione um **tipo de instância** (ex: `t2.micro` para Free Tier).  
4. Em **User Data**, adicione o seguinte script para configurar o ambiente automaticamente:

```bash
#!/bin/bash
apt update && apt upgrade -y
apt install -y nfs-common docker.io docker-compose
systemctl enable docker
systemctl start docker

mkdir -p /mnt/efs
mount -t nfs4 <EFS-ENDPOINT>:/ /mnt/efs

mkdir -p /home/ubuntu/wordpress
cd /home/ubuntu/wordpress

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

docker-compose up -d
```

---



## 📌 5. Criando o Load Balancer  
1. Vá para **EC2 > Load Balancers** e clique em **Create Load Balancer**.  
2. Escolha **Application Load Balancer**.  
3. Defina:  
   - **Listeners** na porta **80** e **443**.  
   - **Target Group** com a instância **EC2** rodando o WordPress.  
4. Configure o **Health Check** na porta **80**.  
5. Associe o Load Balancer ao Security Group correto.  

---

## 📌 6. Acessando o WordPress  
1. Após o deploy, acesse o WordPress em:  
   ```
   http://<DNS-DO-LOAD-BALANCER>
   ```  
2. Complete a instalação do WordPress normalmente.  

---

## 🎯 Conclusão  
Agora você tem um **WordPress escalável e seguro** rodando na AWS com:  
✅ **EC2 + Docker**  
✅ **RDS para o banco de dados**  
✅ **EFS para armazenamento**  
✅ **Load Balancer para distribuir tráfego**  

🚀 **Deploy pronto para produção!**

