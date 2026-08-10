variable "appServiceTemplate" {
  description = "App Service template to deploy"
  type        = any
  default     = {}
}


module "appServiceTemplate" {
  # TODO: bump to the next published tag once the azurerm ~> 5.0 upgrade PR
  # (child refs AppServicePlan/appServiceLinux v1.2.0, appServiceWindows v1.1.0)
  # is merged and released - v1.1.1 is still the pre-upgrade, azurerm ~> 4.0 tag.
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app-service-blueprint-no-ase.git?ref=v1.1.1"
  # source = "/home/max/devops/modules/terraform-azurerm-caf-app-service-template"
  for_each = var.appServiceTemplate

  userDefinedString  = each.key
  location           = var.location
  env                = var.env
  group              = var.group
  project            = var.project
  resource_groups    = local.resource_groups_all
  subnets            = local.subnets
  appServiceTemplate = each.value
  vnet               = local.Project-vnet
  tags               = var.tags
}