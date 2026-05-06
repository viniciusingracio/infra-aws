output "public_ip" {
  description = "IP público da instância Ubuntu."
  value       = aws_instance.ubuntu.public_ip
}

output "public_dns" {
  description = "DNS público da instância Ubuntu."
  value       = aws_instance.ubuntu.public_dns
}

output "ssh_command" {
  description = "Comando SSH para acessar a instância."
  value       = "ssh -i ${pathexpand(var.private_key_path)} ubuntu@${aws_instance.ubuntu.public_ip}"
}

output "ansible_inventory" {
  description = "Arquivo de inventário gerado para o Ansible."
  value       = local_file.ansible_inventory.filename
}
