include dev/.env
export PATH := $(shell pwd)/tmp:$(PATH)

.ONESHELL .PHONY: up update-box destroy-box remove-tmp clean example
.DEFAULT_GOAL := up

###################################
########## Color Scheme ###########
###################################
BLACK        := \033[0;30m
RED          := \033[0;31m
GREEN        := \033[0;32m
ORANGE       := \033[0;33m
BLUE         := \033[0;34m
PURPLE       := \033[0;35m
CYAN         := \033[0;36m
LIGHTGREY    := \033[0;37m
DARKGREY     := \033[1;30m
YELLOW       := \033[1;33m
WHITE        := \033[1;37m
RESET        := \033[0m

###################################
########## Development ############
###################################
dev: update-box custom_ca
	SSL_CERT_FILE=${SSL_CERT_FILE} CURL_CA_BUNDLE=${CURL_CA_BUNDLE} CUSTOM_CA=${CUSTOM_CA} ANSIBLE_ARGS='--skip-tags "test"' vagrant up --provision

up: update-box custom_ca
ifeq ($(GITHUB_ACTIONS),true) # Always set to true when GitHub Actions is running the workflow. You can use this variable to differentiate when tests are being run locally or by GitHub Actions.
	SSL_CERT_FILE=${SSL_CERT_FILE} CURL_CA_BUNDLE=${CURL_CA_BUNDLE} ANSIBLE_ARGS='--extra-vars "ci_test=true"' vagrant up --provision
else
	SSL_CERT_FILE=${SSL_CERT_FILE} CURL_CA_BUNDLE=${CURL_CA_BUNDLE} CUSTOM_CA=${CUSTOM_CA} vagrant up --provision
endif

test: clean up

status:
	vagrant global-status

###################################
######### Pre requisites ##########
###################################
install:
	 mkdir -p tmp;(cd tmp; git clone --depth=1 https://github.com/fredrikhgrelland/vagrant-hashistack.git; cd vagrant-hashistack; make install); rm -rf tmp/vagrant-hashistack

check_for_consul_binary:
ifeq (, $(shell which consul))
	$(error "No consul binary in $(PATH), download the consul binary from here :\n https://www.consul.io/downloads\n\n' && exit 2")
endif

check_for_terraform_binary:
ifeq (, $(shell which terraform))
	$(error "No terraform binary in $(PATH), download the terraform binary from here :\n https://www.terraform.io/downloads.html\n\n' && exit 2")
endif

check_for_docker_binary:
ifeq (, $(shell which docker))
	$(error "No docker binary in $(PATH), install docker from here :\n https://docs.docker.com/get-docker/\n\n' && exit 2")
endif

###################################
######### Clean commands ##########
###################################
destroy-box:
	vagrant destroy -f

remove-tmp:
	rm -rf ./tmp
	rm -rf ./.vagrant
	rm -rf ./.minio.sys
	rm -rf ./example/.terraform
	rm -rf ./example/.terraform.*
	rm -rf ./example/terraform.*
	rm -rf ./example/**/.terraform
	rm -rf ./example/**/.terraform.*
	rm -rf ./example/**/terraform.*

clean: destroy-box remove-tmp

###################################
######### Helper commands #########
###################################
custom_ca:
ifdef CUSTOM_CA
	cp -f ${CUSTOM_CA} docker/conf/certificates/
endif

update-box:
	@SSL_CERT_FILE=${SSL_CERT_FILE} CURL_CA_BUNDLE=${CURL_CA_BUNDLE} vagrant box update || (echo '\n\nIf you get an SSL error you might be behind a transparent proxy. \nMore info https://github.com/fredrikhgrelland/vagrant-hashistack/blob/master/README.md#proxy\n\n' && exit 2)

pre-commit: check_for_docker_binary check_for_terraform_binary
	docker run -e RUN_LOCAL=true -v "${PWD}:/tmp/lint/" github/super-linter
	terraform fmt -recursive && echo "\e[32mTrying to prettify all .tf files.\e[0m"

###################################
######## Template specific ########
###################################
template_example: custom_ca
ifeq ($(GITHUB_ACTIONS),true) # Always set to true when GitHub Actions is running the workflow. You can use this variable to differentiate when tests are being run locally or by GitHub Actions.
	cd template_example; SSL_CERT_FILE=${SSL_CERT_FILE} CURL_CA_BUNDLE=${CURL_CA_BUNDLE} ANSIBLE_ARGS='--extra-vars "ci_test=true"' vagrant up --provision
else
	if [ -f "docker/conf/certificates/*.crt" ]; then cp -f docker/conf/certificates/*.crt template_example/docker/conf/certificates; fi
	cd template_example; SSL_CERT_FILE=${SSL_CERT_FILE} CURL_CA_BUNDLE=${CURL_CA_BUNDLE} CUSTOM_CA=${CUSTOM_CA} vagrant up --provision
endif

template_init:
	# 
	@echo "${RED}\nWarning! This will clean your template. Do you want to continue? [y/n]${RESET}" ; \
	read answer; \
	if [ "$$answer" != "y" ]; then \
		echo "Aborting!" ; \
		exit 1 ; \
	fi 

	@echo "\nStarting to clean your template!" 

	@for folder in "template_example" "example/vagrant_box_example" "CHANGELOG.md" ; do \
		echo "Deleting: $$folder " ; \
		rm -rf $$folder && echo "${GREEN}Success${RESET}" || echo "${RED}Failed${RESET}" ; \
	done

	@echo -n "\nMoving README.md to .github/template_specific as old_README.md " 
	mv README.md .github/template_specific/old_README.md && echo "${GREEN}Success${RESET}" || echo "${RED}Failed${RESET}"

	@echo -n "Moving GETTING_STARTED/ to .github/template_specific/GETTING_STARTED "
	mv GETTING_STARTED .github/template_specific/ && echo "${GREEN}Success${RESET}" || echo "${RED}Failed${RESET}"

	@echo -n "\nCreating a clean README.md "
	cat .github/template_specific/README_template.md >> README.md && echo "${GREEN}Success${RESET}" || echo "${RED}Failed${RESET}"

	@echo -n "Creating a clean CHANGELOG.md "
	echo "# Changelog\n\n## 0.0.1 [UNRELEASED]\n\n###Added\n\n###Changed\n\n###Fixed\n" >> CHANGELOG.md && echo "${GREEN}Success${RESET}" || echo "${RED}Failed${RESET}"

	@echo "${BLUE}\nDone! You are all set to start developing!${RESET}"
	@echo "${YELLOW}\nPS! If you want to keep a deleted folder, you can undo by running:\n  git reset HEAD <file/folder>\n  git checkout -- <file/folder>${RESET}"
