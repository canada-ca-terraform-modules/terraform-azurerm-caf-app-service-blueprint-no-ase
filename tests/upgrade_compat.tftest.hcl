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

run "baseline_apply" {
  command = apply

  variables {
    appServiceTemplate = {}
  }

  assert {
    condition     = length(output.appServiceTemplate_asp) == 0
    error_message = "Baseline apply should produce no app service plan outputs for an empty template"
  }
}

run "upgrade_plan_no_replacement" {
  command = plan

  variables {
    appServiceTemplate = {}
  }

  assert {
    condition     = length(output.appServiceTemplate_asp) == 0
    error_message = "Upgrade plan should preserve baseline no-resource behavior"
  }
}
