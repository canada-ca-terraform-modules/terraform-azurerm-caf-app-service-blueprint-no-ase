# test_dependencies.tf
# Self-contained dependency resources, owned entirely by this harness.
#
# The blueprint's child modules exercised by this harness (app_service_plan,
# app_service_linux, app_service_windows) only need a resource group as a
# dependency - no vnet/subnet input is exercised (private_endpoint /
# custom-domain features are deliberately out of scope). Deliberately NOT
# reusing any shared/production resource group: writing into a shared RG
# usually requires elevated, non-sandbox permissions. A dedicated throwaway
# RG here needs only Contributor on the sandbox subscription and can never
# collide with or affect any production resource.

resource "azurerm_resource_group" "live_test" {
  # PR-number suffix keeps two concurrently open PRs against this module from
  # colliding on the same sandbox resource group.
  name     = "${var.env}-caf-app-service-blueprint-live-test-${var.pr_number}-rg"
  location = var.location

  # pr-number tag: lets the nightly orphan sweeper find this RG by tag and
  # match it back to a PR, independent of naming convention.
  # repository tag: the sandbox subscription is shared across module repos,
  # so the sweeper must scope its `pr-number` matches to only this repo's
  # own PRs - otherwise a PR number collision across repos could
  # misclassify (or destroy) another repo's live resource group.
  tags = {
    "pr-number"  = var.pr_number
    "repository" = var.repository
  }
}

locals {
  # Keyed map matching the shape appServicePlan/appService.resource_group
  # expects to index into (resource_groups[<key>].name)
  resource_groups = {
    probe = {
      name     = azurerm_resource_group.live_test.name
      location = azurerm_resource_group.live_test.location
    }
  }
}
