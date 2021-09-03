# Changelog

## [0.2.0]

## Added
- `make lint` #105
- `make fmt`
- `make destroy-all-running-boxes` added as a fix-all-my-virtualbox-vagrant-problems-now #84
- Github action "Concurrency"
- Build docker image and host them on ghcr.io #108
- Build test images and host them on ghcr.io test_containers.yml

### Changed
- Fixed links to reflect new repo owner #99
- New box -> [Skatteetaten/hashistack](https://app.vagrantup.com/Skatteetaten/boxes/hashistack) #103
- `make precommit` will run `fmt`and `lint`
- Superlinter update to v4
- update github actions to mirror v0.11 of box
- Lint only changed files on Pull Requests
- Schedule CI/CD Daily at 05:30
- remove `project` checkbox from issue templates.
- Testing workflow will not fail fast when a job in the matrix fails
- Use slim linter

### Fixed
- Docker authentication #100
- Improve cleaning of temporary files from build/test procedures

## [0.1.2]

### Fixed

- Fix docker auth login for github actions #100

## [0.1.1]

### Added
- `example_template` logs in to docker registry based on env or config.json

### Changed
- Updated to `vagrant-hashistack` version 0.10
- Moved colour definitions of ‘template_init’ recipe into variables. [no issue]
- Super-linter is run with excluding-mask, only excluding `TERRAGRUNT` linter
- Super-linter is run from ghcr.io locally and in github actions

### Fixed
- bug where 'make template_init' would crash on End of File error. [#92](https://github.com/Skatteetaten/vagrant-hashistack-template/issues/92)
- Link #94
- Link #95
- Some links in documentation [no issue]
- Linting errors [no issue]

## [0.1.0 UNRELEASED]

### Added
- Added github templates for issues and PR #55
- Added healthcheck for countdash nomad job #56
- All folders contains a README.md with fitting description [no issue]
- Getting started tutorials [no issue]
- Added option to login to docker registry #467

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
