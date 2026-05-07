# Infra AWS com Terraform e Ansible

Projeto prático de Infraestrutura como Código usando Terraform e Ansible para provisionar e configurar uma instância Ubuntu na AWS.

## Tecnologias utilizadas

- Terraform
- Ansible
- AWS EC2
- Ubuntu Server
- SSH
- Security Groups
- AWS SSM Parameter Store

## O que o projeto faz

- Cria uma instância EC2 Ubuntu
- Cria um Security Group liberando SSH apenas para o IP informado
- Cria uma Key Pair na AWS
- Gera automaticamente o inventário do Ansible
- Atualiza o sistema operacional
- Instala pacotes básicos no servidor

## Como executar

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply