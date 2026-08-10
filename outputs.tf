locals {
  asp_output = { for key, out in module.AppServicePlan : key => out }
  asv_output = merge({ for key, out in module.appServiceLinux : key => out }, { for key, out in module.appServiceWindows : key => out })
}
output "appServiceTemplate-asp" {
  description = "Outputs the ASP object associated with the template"
  value       = local.asp_output
  sensitive   = true
}

output "appServiceTemplate-asv" {
  description = "Outputs the App services associated with the template"
  value       = local.asv_output
  sensitive   = true
}

output "appServiceTemplate_asp" {
  description = "Compatibility alias for appServiceTemplate-asp"
  value       = local.asp_output
  sensitive   = true
}

output "appServiceTemplate_asv" {
  description = "Compatibility alias for appServiceTemplate-asv"
  value       = local.asv_output
  sensitive   = true
}