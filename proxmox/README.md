# Proxmox VE

Proxmox VE is a virtualization platform, built on top KVM and Qemu technologies

## Provider

The default provider is `Telman/Proxmox`

-   [Source Code](https://github.com/Telmate/terraform-provider-proxmox)
-   [Terraform Registry](https://registry.terraform.io/providers/Telmate/proxmox/latest)

## Projects

| Provider | Projects                                      | Description                                   | Resources         |
| -------- | --------------------------------------------- | --------------------------------------------- | ----------------- |
| Proxmox  | [Simple Vitual Machine](./1-virtual-machine/) | Single VM deployed to a target proxmox server | `proxmox_vm_qemu` |

## FAQs

### How to securely pass credentials to Terraform ?
