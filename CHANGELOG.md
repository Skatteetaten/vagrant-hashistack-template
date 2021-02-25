# Changelog

## [0.1.1 UNRELEASED]

### Changed
- Moved colour definitions of ‘template_init’ recipe into variables. [no issue]

### Fixed
- bug where 'make template_init' would crash on End of File error. [#92](https://github.com/fredrikhgrelland/vagrant-hashistack-template/issues/92)

## [0.1.0 UNRELEASED]

### Added
- Added github templates for issues and PR #55
- Added healthcheck for countdash nomad job #56
- All folders contains a README.md with fitting description [no issue]
- Getting started tutorials [no issue]

### Changed
- Updated to fit hashistack v0.7.0 #66
- Updated READMEs to fit vagrant box 0.6.x #52
- Moved getting started guides in own folder and did a small restructure in README_template.md [no issue]
- Changed set-env to environment files #68
- Tflinter `terraform_required_providers` set to false #14
- Added `make template_init`, updated READMEs and did some restructure in the reposetory #83

### Fixed
- Fixed broken links in READMEs #65
- Box can receive ansible arguments #57
- Moved .env to dev/ folder #64

## [0.0.1 UNRELEASED]

### Changed

- updated documentation: consul namespaces #28
- trigger tests for template_example by condition #12
- updated the make clean in makefile to remove more tmp files/folders #8
- updated up and template_example targets in makefile to use ci_test instead of local_test variable #38
- updated Makefile `pre-commit` with `check_for_terraform_binary` #41
- updated up and template_example targets in makefile #45
- bumped vagrant-hashistack version to 0.5 #50

### Added

- Added command that formats/prettify all `.tf`-files in directory #21 (overwritten by #24)
- Added check for consul and terraform binary in the `Makefile` #20
- Added `make pre-commit` command that use local linter and formatts/prettyfies all `.tf` files #24
- `Vault PKI` section to README
- Token for terraform-provider-vault #35
- Section how to sync modules with the latest template #32
- Added changelog enforcer to pipeline checks #31
- Added getting-started-modules and getting-started-vagrant-box #16

### Fixed

- links in documentation #5
