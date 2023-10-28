variable "organization" {
  description = "The terraform cloud organization"
  type        = string
  default     = "hxrd"
}

variable "container_cpu" {
  description = "The cpu amount"
  type        = number 
  default     = 0.25
}

variable "container_memory" {
  description = "The container memory"
  type        = string
  default     = "0.5Gi"
}

variable "registry_server" {
  description = "The container registry server"
  type        = string
  default     = "ghcr.io"
}

variable "registry_user" {
  description = "The container registry username"
  type        = string
  default     = "HX-Rd"
}

variable "registry_secret_name" {
  description = "The container registry password"
  type        = string
  default     = "GITHUB_API_TOKEN"
}

variable "container_image" {
  description = "The container image"
  type        = string
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}

variable "common_workspace" {
  description = "The terraform cloud workspace"
  type        = string
}

variable "domain" {
  description = "The root domain"
  type        = string
}

variable "subdomain" {
  description = "The root domain"
  type        = string
}

variable "GITHUB_API_TOKEN" {
  descriptio  = "The github api token"
  type = string
  sensitive = true
}

