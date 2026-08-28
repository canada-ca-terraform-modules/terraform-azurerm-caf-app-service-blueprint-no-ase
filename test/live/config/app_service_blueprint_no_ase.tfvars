# Minimal, valid fixture exercising the module's common path - a Linux App
# Service Plan + Linux App Service, and a Windows App Service Plan + Windows
# App Service (both share the one AppServicePlan module). private_endpoint
# and custom-domain features are deliberately out of scope for this harness.
#
# IMPORTANT: keep this file byte-for-byte identical across the baseline
# (target branch) apply and the PR-branch apply - the live-test run
# validates that the SAME tfvars produce the SAME plan under both checkouts.

appServiceTemplate = {
  probe = {
    appServicePlan = {
      linuxPlan = {
        resource_group = "probe"
        os_type        = "Linux"
        sku_name       = "B1"
      }
      windowsPlan = {
        resource_group = "probe"
        os_type        = "Windows"
        sku_name       = "B1"
      }
    }

    appService = {
      linuxTest = {
        resource_group                           = "probe"
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

      windowsTest = {
        resource_group                           = "probe"
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
