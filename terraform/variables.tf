variable "aws_region" {
  description = "Região da AWS onde a instância será criada."
  type        = string
  default     = "sa-east-1"
}

variable "aws_profile" {
  description = "Perfil local da AWS CLI. Deixe vazio para usar o perfil default/variáveis de ambiente."
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Nome usado nas tags dos recursos."
  type        = string
  default     = "terraform-ansible-ubuntu"
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t3.micro"
}

variable "ubuntu_version" {
  description = "Versão do Ubuntu usada na AMI oficial da Canonical via SSM Parameter Store. Exemplo: 22.04."
  type        = string
  default     = "22.04"
}

variable "key_name" {
  description = "Nome do Key Pair criado na AWS."
  type        = string
  default     = "terraform-ansible-ubuntu"
}

variable "public_key_path" {
  description = "Caminho da sua chave pública SSH local."
  type        = string
  default     = "~/.ssh/aws_terraform_ansible.pub"
}

variable "private_key_path" {
  description = "Caminho da sua chave privada SSH local, usada pelo Ansible."
  type        = string
  default     = "~/.ssh/aws_terraform_ansible"
}

variable "allowed_ssh_cidr" {
  description = "CIDR autorizado a acessar SSH. Use seu IP público com /32, exemplo: 200.100.50.25/32."
  type        = string

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Informe um CIDR válido, exemplo: 200.100.50.25/32."
  }
}

variable "root_volume_size" {
  description = "Tamanho do disco raiz em GB."
  type        = number
  default     = 20
}
