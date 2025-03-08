### Arquitetura do Projeto
1. O projeto consiste em uma arquitetura escalável e altamente disponível na AWS, utilizando os seguintes serviços:

2. Amazon EC2: Instâncias para hospedar o WordPress.

3.  Amazon RDS: Banco de dados MySQL para o WordPress.

4. Amazon EFS: Armazenamento de arquivos do WordPress (temas, plugins, uploads).

5. Auto Scaling Group: Garante que o número de instâncias EC2 seja ajustado automaticamente com base na demanda.

6. Load Balancer: Distribui o tráfego entre as instâncias EC2.

### Serviços Utilizados
#### Amazon EC2:

Instâncias para hospedar o WordPress.

Configuradas com Docker para rodar o WordPress.

#### Amazon RDS:

Banco de dados MySQL para armazenar os dados do WordPress.

Endpoint: compass.cfayu2u66e7w.us-east-1.rds.amazonaws.com.

#### Amazon EFS:

Armazenamento de arquivos do WordPress (temas, plugins, uploads).

Montado nas instâncias EC2 para persistência de dados.

#### Auto Scaling Group:

Ajusta automaticamente o número de instâncias EC2 com base na demanda.

Garante alta disponibilidade e escalabilidade.

#### Load Balancer:

Distribui o tráfego entre as instâncias EC2.

Garante que o site esteja sempre disponível.

### Passos para Configuração
#### 1. Configuração do RDS
 Criar um banco de dados MySQL no RDS.

 Configurar o endpoint, usuário, senha e nome do banco de dados.

#### 2. Configuração do EC2
 Criar instâncias EC2 com Docker instalado.

 Configurar o grupo de segurança para permitir tráfego HTTP (porta 80) e SSH (porta 22).

#### 3. Configuração do WordPress com Docker
 Criar um arquivo docker-compose.yml para rodar o WordPress.

 Mapear o EFS para armazenar os arquivos do WordPress.

#### 4. Configuração do Auto Scaling Group
 Criar um Auto Scaling Group para gerenciar as instâncias EC2.

 Definir políticas de escalabilidade com base na demanda.

#### 5. Configuração do Load Balancer
 Criar um Application Load Balancer (ALB) para distribuir o tráfego.

 Configurar o grupo de segurança para permitir tráfego HTTP (porta 80).

#### Possiveis erros
#### Erro: "Error establishing a database connection"

Verifique as credenciais do banco de dados no docker-compose.yml.

Teste a conexão com o RDS a partir da instância EC2.

#### Erro: "Permission denied" ao usar Docker Compose

Adicione o usuário ao grupo docker:
sudo usermod -aG docker $USER
Reinicie a sessão.

#### **Erro: "Unknown database 'compass'"`

Conecte-se ao RDS e crie o banco de dados compass:
CREATE DATABASE compass;

