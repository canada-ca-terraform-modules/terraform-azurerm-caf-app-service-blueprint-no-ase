mock_provider "azurerm" {}
mock_provider "azuread" {}

variables {
  env               = "Dev"
  group             = "GRP"
  project           = "PRJ"
  userDefinedString = "test"
  location          = "canadacentral"
  resource_groups   = {}
  subnets           = {}
  vnet              = null
  tags              = {}
}

run "naming_convention" {
  command = plan

  variables {
    appServiceTemplate = {}
  }

  assert {
    condition     = "${var.env}SLD-${var.userDefinedString}-ci" == "DevSLD-test-ci"
    error_message = "Expected default naming convention string to match ESLZ format"
  }
}

run "default_values" {
  command = plan

  variables {
    appServiceTemplate = {}
  }

  assert {
    condition     = length(output.appServiceTemplate_asp) == 0
    error_message = "Expected no app service plan outputs when appServiceTemplate is empty"
  }

  assert {
    condition     = length(output.appServiceTemplate_asv) == 0
    error_message = "Expected no app service outputs when appServiceTemplate is empty"
  }
}
