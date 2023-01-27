resource "proxmox_vm_qemu" "pve_vm" {
  name        = "VM"
  target_node = var.proxmox_target_node
  iso         = "${var.proxmox_iso_repository_storage_id}:iso/<filename>.iso"
  memory      = var.proxmox_vm_memory
  cores       = var.proxmox_vm_cores
  disk {
    storage = var.proxmox_vm_storage
    type    = "scsi"
    size    = var.proxmox_vm_storage_size
  }
}