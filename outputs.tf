locals {
  asp-output = {for key, out in  module.AppServicePlan: key => out}
  asv-output = merge({for key, out in module.appServiceLinux: key => out}, {for key, out in module.appServiceWindows: key => out})
}
output "appServiceTemplate-asp" {
  description = "Outputs the ASP object associated with the template"
  value = local.asp-output
}

output "appServiceTemplate-asv" {
  description = "Outputs the App services associated with the template"
  value = local.asv-output
}