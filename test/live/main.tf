terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }

  # Empty on purpose: the state file path is supplied at `terraform init`
  # time via `-backend-config="path=..."` (partial configuration), so the
  # target-branch checkout and the PR-branch checkout can point at the same
  # external state file without either owning its own local state.
  backend "local" {}
}

provider "azurerm" {
  storage_use_azuread             = true
  resource_provider_registrations = "legacy"
  features {}
}

provider "azuread" {}

module "appServiceTemplate" {
  # PR code and baseline code are two on-disk checkouts of this same repo,
  # not two resolved git refs - no pinned ?ref, no version toggle here.
  source = "../../"

  for_each = var.appServiceTemplate

  userDefinedString  = each.key
  location           = var.location
  env                = var.env
  group              = var.group
  project            = var.project
  resource_groups    = local.resource_groups # from test_dependencies.tf
  subnets            = null
  appServiceTemplate = each.value
  vnet               = {} # required by the module but unused (dead variable - see module's own NOTE)
  tags               = var.tags
}
