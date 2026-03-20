locals {
  app_service_plan = try(var.appServiceTemplate.appServicePlan, {})
  app_service      = try(var.appServiceTemplate.appService, {})

  # Keep defaults safe when callers omit nested keys in appServiceTemplate.
  appServiceLinux   = { for app, v in local.app_service : app => v if try(local.app_service_plan[v.asp].os_type, null) == "Linux" }
  appServiceWindows = { for app, v in local.app_service : app => v if try(local.app_service_plan[v.asp].os_type, null) == "Windows" }
  asp_id            = { for name, param in local.app_service_plan : name => module.AppServicePlan[name].asp_id }
}