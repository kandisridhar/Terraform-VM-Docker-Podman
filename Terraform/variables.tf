# Input Variables
variable "resoure_group_name" {
  description = "Resource Group Name"
  type = string
  default = "myrg--test"
}

variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastasia"
}

variable "pip_name" {
  description = "VM public Ip"
  type = string 
  default = "vmpublicip-test"
}

variable "nic_name" {
  description = "Network Interface card"
  type = string 
  default = "nic_name-test"
}

variable "appvm" {
  description = "VM Name"
  type = string 
  default = "appvm-test1"
}