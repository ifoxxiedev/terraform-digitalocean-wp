
variable "region" {
  type    = string
  default = "nyc1"
}

variable "wp_vm_count" {
  type        = number
  default     = 2
  description = "Numero de máquinas para o wordpress"
  validation {
    condition     = var.wp_vm_count > 0
    error_message = "O número de máquinas para o wordpress precisa ser maior ou igual a 1"
  }
}

variable "wp_db_user" {
  type        = string
  default     = "wordpress"
  description = "Nome de usuário para o banco de dados Workdpress"
}

variable "wp_db_name" {
  type        = string
  default     = "wp-database"
  description = "Nome do banco de dados Workdpress"
}


variable "wp_vms_ssh" {
  type        = string
  description = "Fingerprint da chave ssh"
}
