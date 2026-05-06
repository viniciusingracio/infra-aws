provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "" ? var.aws_profile : null
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/${var.ubuntu_version}/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name    = var.key_name
    Project = var.project_name
  }
}

resource "aws_security_group" "ssh" {
  name        = "${var.project_name}-ssh"
  description = "Permite SSH somente do CIDR configurado"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH do IP permitido"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Saida liberada"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-ssh"
    Project = var.project_name
  }
}

resource "aws_instance" "ubuntu" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name    = "${var.project_name}-ec2"
    Project = var.project_name
    OS      = "Ubuntu"
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<-EOT
  [ubuntu]
  ${aws_instance.ubuntu.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${pathexpand(var.private_key_path)} ansible_python_interpreter=/usr/bin/python3

  [ubuntu:vars]
  ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT
}
