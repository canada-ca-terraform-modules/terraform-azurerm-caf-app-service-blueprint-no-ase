# `test/live/` - live-test harness

A live, real-Azure-resource harness used by the `live-test` PR check (see
the [`live-test-actions`](https://github.com/canada-ca-terraform-modules/live-test-actions)
repo and this module's own `.github/workflows/live-test.yml`) to prove that
an open PR doesn't destroy or replace a resource a real consumer already
has running. It is **not** a substitute for either of the module's other
test surfaces:

- **`tests/*.tftest.hcl`** - mock-based unit tests (`terraform test`, no
  provider credentials, no live Azure resources). Run these first; they're
  fast and free.
- **`ESLZ/`** / **`L2_portal_app_service/`** - usage examples. Not exercised
  by CI at all; documentation only.
- **`test/live/`** (this directory) - a single, real instance of the module
  applied against a disposable Azure sandbox subscription. Used by CI to
  diff the PR's plan against a live baseline, and can be run manually by a
  maintainer the same way.

## What's here

| File | Purpose |
|---|---|
| `main.tf` | Module block with `source = "../../"` (a relative path, not a pinned `?ref` - "baseline" and "PR" are just two on-disk checkouts of this repo), the `azurerm`/`azuread` provider config, and an empty `backend "local" {}` block (path supplied at `init` time - see below). |
| `test_dependencies.tf` | A dedicated, throwaway resource group this harness owns outright - never a shared/production resource group. Its name is suffixed with `var.pr_number` so concurrently open PRs never collide. |
| `variables.tf` | `env`, `group`, `project`, `location` (defaults to `canadacentral`), `tags`, `pr_number` (defaults to `"manual"`), `repository`, and `appServiceTemplate` (typed `any`, passed straight through to the module). |
| `config/app_service_blueprint_no_ase.tfvars` | One representative fixture covering both OS types: a Linux App Service Plan + Linux App Service, and a Windows App Service Plan + Windows App Service (both share the one `AppServicePlan` module). `private_endpoint` / custom-domain features are out of scope. |

The module also declares a required `vnet` input that isn't actually
referenced anywhere in the module's own `module.tf`/`locals.tf` (dead
variable, likely a leftover from a removed custom-domain DNS feature) - the
harness passes a literal placeholder (`{}`) instead of deploying a real
vnet, same as the upstream `L2_test_app_service_blueprint_no_ase` probe
harness does.

No Terragrunt anywhere under this directory - a single harness per repo has
no cross-harness DRY need.

## Running it manually

Requires your own `az login` session against the sandbox subscription (CI
uses OIDC instead).

```bash
cd test/live
terraform init
terraform plan  -var-file=config/app_service_blueprint_no_ase.tfvars
terraform apply -var-file=config/app_service_blueprint_no_ase.tfvars
```

Confirm only the live-test resource group and `module.appServiceTemplate`
resources are planned/applied, then tear it down:

```bash
terraform destroy -var-file=config/app_service_blueprint_no_ase.tfvars
```

No `.tfstate` file is ever committed under `test/live/` - every run is
fully ephemeral, whether run by CI or by hand.

## Two-checkout state isolation (baseline vs. PR)

CI proves a PR isn't a breaking change by applying the target branch as a
live baseline, then plan/apply-ing the PR branch's checkout of this same
harness against that same live state - two on-disk checkouts of this repo,
one shared external state file, no state copying between them:

```bash
# Directory A: PR branch checkout, directory B: target branch checkout.
STATE=$RUNNER_TEMP/live-test-<pr-number>.tfstate

# 1. Baseline apply, from B.
cd B/test/live
terraform init -backend-config="path=$STATE"
terraform apply -var-file=config/app_service_blueprint_no_ase.tfvars -var="pr_number=<pr-number>"

# 2. PR plan (and, in CI, apply), from A, against the same state file.
cd A/test/live
terraform init -backend-config="path=$STATE"
terraform plan -var-file=config/app_service_blueprint_no_ase.tfvars -var="pr_number=<pr-number>"

# 3. Always tear down from A once the run finishes (`if: always()` in CI).
terraform destroy -var-file=config/app_service_blueprint_no_ase.tfvars -var="pr_number=<pr-number>"
```

`pr_number` (`TF_VAR_pr_number` in CI, sourced from `github.event.number`)
suffixes every `test_dependencies.tf` resource name, so two concurrently
open PRs against this module - each pointed at their own
`live-test-<pr-number>.tfstate` - never collide on the same sandbox
resource group.

To verify this locally without CI: check out this branch into two
directories, run step 1 from one and step 2 from the other against a
shared local state file path, and confirm the plan in step 2 diffs against
the resources step 1 actually created (not an empty/fresh-state plan).
