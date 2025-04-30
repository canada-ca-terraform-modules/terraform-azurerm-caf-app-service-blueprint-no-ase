module "AppServicePlan" {
  source = "github.com/canada-ca-terraform-modules/terraform-caf-azurerm-app_service_plan.git?ref=v1.0.4"
  for_each = var.appServiceTemplate.appServicePlan

  userDefinedString = "${var.userDefinedString}-${each.key}"
  env = var.env
  group = var.group
  project = var.project
  resource_groups = var.resource_groups
  subnets = var.subnets
  appServicePlan = each.value
  tags = var.tags
}

module "appServiceLinux" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app_service_linux.git?ref=v1.0.3"
  for_each = local.appServiceLinux

  userDefinedString = "${var.userDefinedString}-${each.key}"
  env = var.env
  group = var.group
  project = var.project
  resource_groups = var.resource_groups
  subnets = var.subnets
  appServiceLinux = each.value
  asp = local.asp_id
  tags = var.tags
}

module "appServiceWindows" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app_service_windows.git?ref=v1.0.2"
  for_each = local.appServiceWindows

  userDefinedString = "${var.userDefinedString}-${each.key}"
  env = var.env
  group = var.group
  project = var.project
  resource_groups = var.resource_groups
  subnets = var.subnets
  appServiceWindows = each.value
  asp = local.asp_id
  tags = var.tags
}
