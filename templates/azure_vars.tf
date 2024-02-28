variable "AZ_APP_ID" {
  type    = string
  default = "{{ AZURE_APP_CLIENT_ID }}"
}

variable "AZ_TENANT" {
  type    = string
  default = "{{ AZURE_TENANT_ID }}"
}

variable "AZ_SECRET" {
  type    = string
  default = "{{ AZURE_SECRET }}"
}

variable "AZ_SUB_ID" {
  type    = string
  default = "{{ AZURE_SUB_ID }}"
}
