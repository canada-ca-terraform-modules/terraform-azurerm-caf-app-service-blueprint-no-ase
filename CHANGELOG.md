# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.2.0] - 2026-08-10

### Changed

- Upgraded `azurerm` provider requirement from `~> 4.0` to `~> 5.0` (tested against `azurerm v5.0.1`).
- Bumped `AppServicePlan` module ref from `v1.0.4` to `v1.2.0` (azurerm 5.0 compatible).
- Bumped `appServiceLinux` module ref from `v1.0.4` to `v1.2.0` (azurerm 5.0 compatible).
- Bumped `appServiceWindows` module ref from `v1.0.4` to `v1.1.0` (azurerm 5.0 compatible).
- Bumped `ESLZ/appServiceTemplate.tf` and `L2_portal_app_service/modules/appServiceTemplate.tf` self-referential module `ref=` to `v1.2.0`.
- Added `.github/workflows/release.yml`, matching the release-on-merge convention already used by the child modules this blueprint composes (`terraform-caf-azurerm-app_service_plan`, `terraform-azurerm-caf-app_service_linux`, `terraform-azurerm-caf-app_service_windows`).

### Fixed (PR review follow-up)

- `outputs.tf`: marked `appServiceTemplate-asp`/`-asv` (and their `_` compatibility aliases) `sensitive = true` - fixes a latent bug where a non-empty `appServiceTemplate` plan/apply failed with "Output refers to sensitive values" (nested App Service attributes such as `site_credential`). Only reachable once the template is non-empty, which is why the prior test suite never caught it.
- Added `tests/app_service_routing.tftest.hcl`: exercises a non-empty `appServiceTemplate` with a Linux and a Windows plan + app, validating the `os_type`-based routing in `locals.tf` and the `asp_id` local for both OS types.

### Notes

- No breaking changes to `azurerm_service_plan`, `azurerm_linux_web_app`, or `azurerm_windows_web_app` between azurerm v4.x and v5.0 that affect this blueprint's own `locals.tf`/`outputs.tf` - all breaking-change handling lives in the three child modules.
- Live upgrade probe run against a real Azure subscription in a separate landing zone L2 test harness, covering both a Linux and a Windows App Service Plan + App Service.

## [1.1.1] and earlier

- See git history for changes prior to CHANGELOG.md being introduced.
