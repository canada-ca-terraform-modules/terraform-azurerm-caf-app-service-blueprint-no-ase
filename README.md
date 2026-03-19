## terraform-azurerm-caf-app-service-blueprint-no-ase

Blueprint module that orchestrates App Service Plan plus Linux/Windows App Service child modules from a single ESLZ template object.

## Usage

### ESLZ module block (`ESLZ/appServiceTemplate.tf`)

```hcl
module "appServiceTemplate" {
	source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app-service-blueprint-no-ase.git?ref=<version>"
	for_each = var.appServiceTemplate

	userDefinedString = each.key
	location          = var.location
	env               = var.env
	group             = var.group
	project           = var.project
	resource_groups   = local.resource_groups_all
	subnets           = local.subnets
	appServiceTemplate = each.value
	vnet              = local.Project-vnet
	tags              = var.tags
}
```

### ESLZ tfvars pattern (`ESLZ/appServiceTemplate.tfvars`)

```hcl
appServiceTemplate = {
	template = {
		appServicePlan = {
			plan = {
				resource_group = "portal_app_service"
				os_type        = "Linux"
				sku_name       = "B1"
			}
		}
		appService = {
			web = {
				resource_group = "portal_app_service"
				asp            = "plan"
				site_config = {
					always_on = true
				}
			}
		}
	}
}
```

## Testing

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
terraform test
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_AppServicePlan"></a> [AppServicePlan](#module\_AppServicePlan) | github.com/canada-ca-terraform-modules/terraform-caf-azurerm-app_service_plan.git | v1.0.4 |
| <a name="module_appServiceLinux"></a> [appServiceLinux](#module\_appServiceLinux) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app_service_linux.git | v1.0.4 |
| <a name="module_appServiceWindows"></a> [appServiceWindows](#module\_appServiceWindows) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-app_service_windows.git | v1.0.4 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appServiceTemplate"></a> [appServiceTemplate](#input\_appServiceTemplate) | Object containing all parameters for the Linux App Service | `any` | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | (Required) Env value for the name of the resource | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | (Required) Group value for the name of the resource | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the resource | `string` | `"canadacentral"` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) Project value for the name of the resource | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Resouce group object containing a list of resource group in the target project | `any` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet object containing a list of subnets in the target project | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Maps of tags that will be applied to the resource | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) UserDefinedString value for the name of the resource | `string` | n/a | yes |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | (Required) Vnet ID to link to DNS zone to | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appServiceTemplate-asp"></a> [appServiceTemplate-asp](#output\_appServiceTemplate-asp) | Outputs the ASP object associated with the template |
| <a name="output_appServiceTemplate-asv"></a> [appServiceTemplate-asv](#output\_appServiceTemplate-asv) | Outputs the App services associated with the template |
| <a name="output_appServiceTemplate_asp"></a> [appServiceTemplate\_asp](#output\_appServiceTemplate\_asp) | Compatibility alias for appServiceTemplate-asp |
| <a name="output_appServiceTemplate_asv"></a> [appServiceTemplate\_asv](#output\_appServiceTemplate\_asv) | Compatibility alias for appServiceTemplate-asv |
<!-- END_TF_DOCS -->