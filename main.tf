data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = var.organization
    workspaces = {
      name = var.common_workspace
    }
  }
}

data "azapi_resource" "my_first_app_container_app_environment" {
  resource_id = data.terraform_remote_state.vpc.outputs.container_app_environment_id
  type        = "Microsoft.App/managedEnvironments@2022-11-01-preview"

  response_export_values = ["properties.customDomainConfiguration.customDomainVerificationId"]
}

data "cloudflare_zone" "czone" {
  name = var.domain
}


resource "azurerm_container_app" "container" {
  name                         = var.subdomain
  container_app_environment_id = data.terraform_remote_state.vpc.outputs.container_app_environment_id
  resource_group_name          = data.terraform_remote_state.vpc.outputs.resource_group_id
  revision_mode                = "Single"

  registry {
    server = var.registry_server
    username = var.registry_user
    password_secret_name = "registry-credentials"
  }

  secret {
    name  = "registry-credentials"
    value = secrets.GITHUB_API_TOKEN
  }

  template {
    container {
      name   = var.container_name
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}



resource "cloudflare_record" "CNAME" {
  name = var.subdomain
  type = "CNAME"
  zone_id = data.cloudflare_zone.czone.id
  value = "${var.subdomain}.${data.terraform_remote_state.vpc.outputs.container_app_environment_default_domain}"
}

resource "cloudflare_record" "TXT" {
  name = "asuid.${var.subdomain}.${var.domain}"
  type = "TXT"
  zone_id = data.cloudflare_zone.czone.id
  value = jsondecode(data.azapi_resource.my_first_app_container_app_environment.output).properties.customDomainConfiguration.customDomainVerificationId
}
