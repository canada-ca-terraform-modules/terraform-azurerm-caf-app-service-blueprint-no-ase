mock_provider "azurerm" {}
mock_provider "azuread" {}

variables {
  env               = "Dev"
  group             = "GRP"
  project           = "PRJ"
  userDefinedString = "test"
  location          = "canadacentral"
  resource_groups = {
    rg = {
      name     = "rg-test"
      location = "canadacentral"
    }
  }
  subnets = {}
  vnet    = null
  tags    = {}
}

# Exercises a non-empty appServiceTemplate with one Linux and one Windows App
# Service Plan + App Service - validates the os_type-based routing in
# locals.tf (appServiceLinux/appServiceWindows split) and the asp_id local
# (module.AppServicePlan[name].asp_id) actually resolve for both OS types,
# which the empty-template tests in app_service_blueprint.tftest.hcl and
# upgrade_compat.tftest.hcl never exercise.
run "linux_and_windows_routing" {
  command = plan

  variables {
    appServiceTemplate = {
      appServicePlan = {
        linuxPlan = {
          resource_group = "rg"
          os_type        = "Linux"
          sku_name       = "B1"
        }
        windowsPlan = {
          resource_group = "rg"
          os_type        = "Windows"
          sku_name       = "B1"
        }
      }
      appService = {
        linuxApp = {
          resource_group                           = "rg"
          enabled                                  = true
          https_only                               = true
          asp                                      = "linuxPlan"
          ftp_publish_basic_authentication_enabled = false
          site_config = {
            always_on           = true
            http2_enabled       = true
            minimum_tls_version = "1.2"
          }
        }
        windowsApp = {
          resource_group                           = "rg"
          enabled                                  = true
          https_only                               = true
          asp                                      = "windowsPlan"
          ftp_publish_basic_authentication_enabled = false
          site_config = {
            always_on           = true
            http2_enabled       = true
            minimum_tls_version = "1.2"
          }
        }
      }
    }
  }

  assert {
    condition     = length(output.appServiceTemplate_asp) == 2
    error_message = "Expected one app service plan output per plan entry (Linux + Windows)"
  }

  assert {
    condition     = length(output.appServiceTemplate_asv) == 2
    error_message = "Expected one app service output per app entry (Linux + Windows)"
  }

  assert {
    condition     = contains(keys(output.appServiceTemplate_asv), "linuxApp")
    error_message = "Expected the Linux app service to be routed and present in outputs"
  }

  assert {
    condition     = contains(keys(output.appServiceTemplate_asv), "windowsApp")
    error_message = "Expected the Windows app service to be routed and present in outputs"
  }
}
