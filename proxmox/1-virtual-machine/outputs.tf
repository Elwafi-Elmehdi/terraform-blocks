output "pve_vm_ip" {
  # Only applies when agent is 1 and Proxmox can actually read the ip the vm has
  value = proxmox_vm_qemu.pve_vm.default_ipv4_address
}