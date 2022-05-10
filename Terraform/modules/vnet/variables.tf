variable "rg_name" {
  description = "Resource Group Name"
  type = string
}

variable "rg_location"{
  description = "Resource Group Location"
  type = string
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type = string 
  //default = "myvnet-test"
}

variable "vnet_address_prefix"{
  description = "Vnet address prefix"
  type = list(string)
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  //default     = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  //default     = ["subnet1-test", "subnet2-test"]
}
