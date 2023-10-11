### VM ###
variable "vm_web_image_ubuntu_2004" {
  type        = string
  description = "OS release name"
  default     = "ubuntu-2004-lts"
}

variable "vm_web_platform_id" {
  type        = string
  description = "VM platform_id"
  default     =   "standard-v2"
}

variable "vm_web_cores" {
  type        = number
  description = "VM cores"
  default     = "2"
}

variable "vm_web_memory" {
  type        = number
  description = "VM memory"
  default     = "1"
}

variable "vm_web_core_fraction" {
  type        = number
  description = "VM core fraction"
  default     = "5"
}

