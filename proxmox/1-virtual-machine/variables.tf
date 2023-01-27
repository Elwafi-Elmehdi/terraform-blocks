variable "proxmox_token_id" {
}

variable "proxmox_token_secret" {
}

variable "proxmox_url" {
  type        = string
  description = "The url og the proxmox master node or any active node"
  default     = "https://192.168.1.3:8006/api2/json"
  # Mine's happens to be at the private IP 192.168.1.3 change it to what ever you like
}

variable "proxmox_parallel_tasks" {
  type        = number
  description = "the number of parallel executions that Terraform will trigger when it calls PVE APIS default is 4"
  default     = 10
}

variable "proxmox_target_node" {
  type        = string
  description = "The target group where the resources will be deployed to."
  default     = "pve1"
}

variable "proxmox_vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}
variable "proxmox_vm_memory" {
  description = "Qemu VM Memory Size"
  type        = number
  default     = 2048
}
variable "proxmox_vm_storage_size" {
  description = "Qemu VM Storage Size"
  type        = string
  default     = "10G"
}
variable "proxmox_vm_storage" {
  description = "Storage target volume"
  type        = string
  default     = "local-lvm"
}
variable "proxmox_iso_repository_storage_id" {
  description = "ISO repository ID sotrage"
  type        = string
  default     = "local-lvm"
}