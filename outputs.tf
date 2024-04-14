output "wp_lb_ip" {
  value       = digitalocean_loadbalancer.wp_lb.ip
  description = "IP do Load Balancer"
}

output "wp_vm_ips" {
  value       = digitalocean_droplet.vm_wp[*].ipv4_address
  description = "IPs das máquinas Workdpress(droplet)"
}

output "nfs_vm_ip" {
  value       = digitalocean_droplet.vm_nfs.ipv4_address
  description = "IP da máquina NFS(droplet)"
}

output "wp_db_username" {
  value       = digitalocean_database_user.wp_database_user.name
  description = "Username do banco de dados"
}


# Exibir output com dados sensiveis: $ terraform output wp_db_password
output "wp_db_password" {
  value       = digitalocean_database_user.wp_database_user.password
  description = "Password do banco de dados"
  sensitive   = true # dados sensiveis não exibem o valor
}
