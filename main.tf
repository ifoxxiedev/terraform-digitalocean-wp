terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.34.1"
    }
  }
}

# VPC
resource "digitalocean_vpc" "wp_net" {
  name   = "wp-network"
  region = var.region
}

# LP
resource "digitalocean_loadbalancer" "wp_lb" {
  name   = "wp-lb"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path     = "/"
  }

  vpc_uuid = digitalocean_vpc.wp_net.id

  droplet_ids = digitalocean_droplet.vm_wp[*].id
}


# DROPLET WORDPRESS
resource "digitalocean_droplet" "vm_wp" {
  name     = "vm-wp-${count.index}"
  size     = "s-2vcpu-2gb"
  image    = "ubuntu-22-04-x64"
  region   = var.region
  vpc_uuid = digitalocean_vpc.wp_net.id
  count    = var.wp_vm_count
  ssh_keys = [var.wp_vms_ssh]
}

# DROPLET NSFS
resource "digitalocean_droplet" "vm_nfs" {
  name     = "vm-nfs"
  size     = "s-2vcpu-2gb"
  image    = "ubuntu-22-04-x64"
  region   = var.region
  vpc_uuid = digitalocean_vpc.wp_net.id
  ssh_keys = [var.wp_vms_ssh]

}

# Cluster MySQL (Serviço de Banco de Dados Gerenciado)
resource "digitalocean_database_cluster" "wp_mysql" {
  name                 = "wp-mysql"
  engine               = "mysql"
  version              = "8"
  size                 = "db-s-1vcpu-1gb"
  region               = var.region
  node_count           = 1
  private_network_uuid = digitalocean_vpc.wp_net.id
}

# Criou um banco de dados no cluster de banco
resource "digitalocean_database_db" "wp_database" {
  cluster_id = digitalocean_database_cluster.wp_mysql.id
  name       = var.wp_db_name
}

# Criou um usuário no cluster de banco
resource "digitalocean_database_user" "wp_database_user" {
  cluster_id = digitalocean_database_cluster.wp_mysql.id
  name       = var.wp_db_user
}
