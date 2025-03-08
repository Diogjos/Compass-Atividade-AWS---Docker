## WordPress na AWS com Docker, RDS, EFS e Load Balancer
Este projeto consiste na implantação de uma aplicação WordPress na AWS utilizando Docker, RDS MySQL, EFS para armazenamento de arquivos estáticos e Load Balancer para distribuição de tráfego.
### Requisitos
Conta na AWS.

Instância EC2 (Amazon Linux 2).

Banco de dados RDS MySQL.

Sistema de arquivos EFS.

Load Balancer (Application Load Balancer ou Classic Load Balancer).

Docker e Docker Compose instalados na instância EC2.

Conhecimento básico de AWS, Docker e WordPress.
### Arquitetura da Solução
A arquitetura do projeto é composta pelos seguintes componentes:

EC2: Instância onde o WordPress será executado em um contêiner Docker.

RDS MySQL: Banco de dados gerenciado pela AWS para armazenar os dados do WordPress.

EFS: Sistema de arquivos para armazenar os arquivos estáticos do WordPress (ex: uploads, temas, plugins).

Load Balancer: Distribui o tráfego entre as instâncias EC2 (se houver mais de uma) e fornece um único ponto de acesso para a aplicação.




### Passo a Passo
#### 1. Configuração do EC2
Crie uma instância EC2 com Amazon Linux 2.

Configure o Security Group para permitir:

SSH (porta 22) a partir do seu IP.

HTTP (porta 80) a partir de qualquer IP (0.0.0.0/0).

Utilize o script de User Data para instalar o Docker e configurar a instância automaticamente.
#### 2. Configuração do RDS MySQL
No console da AWS, vá para o serviço RDS.

Crie um banco de dados MySQL.

Anote os seguintes detalhes:

Endpoint do banco de dados.

Nome do banco de dados.

Usuário e senha.

Configure o Security Group do RDS para permitir tráfego na porta 3306 a partir do Security Group da instância EC2.

#### 3. Configuração do EFS

No console da AWS, vá para o serviço EFS.

Crie um sistema de arquivos EFS.

Configure o EFS para ser acessível pela instância EC2.

Monte o EFS na instância EC2:

#### 4.Configuração do Load Balancer
No console da AWS, vá para EC2 > Load Balancers.

Crie um Load Balancer (Application Load Balancer ou Classic Load Balancer).

Configure o Security Group do Load Balancer para permitir tráfego HTTP (porta 80) ou HTTPS (porta 443).

Crie um Target Group e registre a instância EC2.

### Teste e validação

Acesse o DNS do Load Balancer no navegador.

Verifique se a tela de instalação do WordPress é exibida.

Conclua a instalação do WordPress e faça login no painel administrativo.

Verifique se os arquivos estáticos estão sendo armazenados no EFS.

















