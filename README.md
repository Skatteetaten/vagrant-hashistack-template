<!-- markdownlint-disable MD041 -->
<p align="center">
 <img width="100px" src="https://www.svgrepo.com/show/58111/cube.svg" align="center" alt="Vagrant-hashistack" />
 <h2 align="center">Vagrant-hashistack Template</h2>
 <p align="center">Starter template for <a href="https://github.com/fredrikhgrelland/vagrant-hashistack">fredrikhgrelland/vagrant-hashistack</a></p>
<p align="center">
    <a href="https://github.com/fredrikhgrelland/vagrant-hashistack-template/actions">
      <img alt="Build" src="https://github.com/fredrikhgrelland/vagrant-hashistack-template/workflows/CI/CD/badge.svg" />
    </a>
    <a href="https://github.com/fredrikhgrelland/vagrant-hashistack/releases">
      <img alt="Releases" src="https://img.shields.io/github/v/release/fredrikhgrelland/vagrant-hashistack?label=latest%20version" />
    </a>
    <a href="https://github.com/fredrikhgrelland/vagrant-hashistack/commits">
      <img alt="Updated" src="https://img.shields.io/github/last-commit/fredrikhgrelland/vagrant-hashistack-template?label=last%20updated" />
    </a>
    <br />
    <br />
    <p align="center">
      <a href="https://github.com/fredrikhgrelland/vagrant-hashistack-template/generate" alt="Clone Template">
            <img src="https://img.shields.io/badge/Github-Clone%20template-blue?style=for-the-badge&logo=github" />
        </a>
    </p>
</p>

## Content
- [Content](#content)
- [Description - What & Why](#description---what--why)
  - [Why Does This Exist?](#why-does-this-exist)
  - [Services](#services)
    - [Port collisions](#port-collisions)
      - [Option 1 Shut down the running machine](#option-1-shut-down-the-running-machine)
      - [Option 2 Use the `auto_correct` feature to dynamically allocate ports](#option-2-use-the-auto_correct-feature-to-dynamically-allocate-ports)
- [Install Prerequisites](#install-prerequisites)
  - [Packages that needs to be pre-installed](#packages-that-needs-to-be-pre-installed)
    - [MacOS Specific](#macos-specific)
    - [Ubuntu Specific](#ubuntu-specific)
- [Configuration](#configuration)
  - [Startup Scheme](#startup-scheme)
    - [Detailed Startup Procedure](#detailed-startup-procedure)
  - [Pre and Post Hashistack Startup Procedure](#pre-and-post-hashistack-startup-procedure)
    - [Ansible Playbooks Pre and Post Hashistack Startup](#ansible-playbooks-pre-and-post-hashistack-startup)
    - [Bash Scripts Pre and Post Ansible Playbook](#bash-scripts-pre-and-post-ansible-playbook)
  - [Pre-packaged Configuration Switches](#pre-packaged-configuration-switches)
    - [Enterprise vs Open Source Software (OSS)](#enterprise-vs-open-source-software-oss)
    - [Nomad](#nomad)
    - [Consul](#consul)
      - [Enterprise - Namespaces](#enterprise---namespaces)
    - [Vault](#vault)
      - [Consul Secrets Engine](#consul-secrets-engine)
      - [Vault PKI](#vault-pki)
  - [Vagrant Box Resources](#vagrant-box-resources)
- [Getting Started](#getting-started)
  - [Goals of This Guide](#goals-of-this-guide)
  - [Vagrant box vs your local machine](#vagrant-box-vs-your-local-machine)
  - [Interacting with Nomad, Vault and Consul](#interacting-with-nomad-vault-and-consul)
  - [Using ansible](#using-ansible)
  - [Making artifacts availabe inside the box](#making-artifacts-availabe-inside-the-box)
    - [MinIO](#minio)
    - [Synced folder](#synced-folder)
  - [Your First Running Virtual Machine](#your-first-running-virtual-machine)
  - [The development process](#the-development-process)
    - [1. Building Docker Image](#1-building-docker-image)
    - [2. Deploying Container With Nomad](#2-deploying-container-with-nomad)
      - [Making image available to Nomad](#making-image-available-to-nomad)
      - [Creating a nomad job](#creating-a-nomad-job)
    - [3. Creating the Terraform Module](#3-creating-the-terraform-module)
      - [main.tf](#maintf)
      - [variables.tf](#variablestf)
      - [outputs.tf](#outputstf)
    - [4. Using a Terraform Module](#4-using-a-terraform-module)
    - [5. Using Ansible To Run the Code in the Previous Step On Startup](#5-using-ansible-to-run-the-code-in-the-previous-step-on-startup)
    - [6. Making The Nomad Job More Dynamic With Terraform Variables](#6-making-the-nomad-job-more-dynamic-with-terraform-variables)
    - [7. Integrating The Nomad Job With Vault](#7-integrating-the-nomad-job-with-vault)
    - [Github Workflows](#github-workflows)
- [Usage](#usage)
  - [Commands](#commands)
  - [MinIO](#minio-1)
    - [Pushing Resources To MinIO With Ansible (Docker image)](#pushing-resources-to-minio-with-ansible-docker-image)
    - [Fetching Resources From MinIO With Nomad (Docker image)](#fetching-resources-from-minio-with-nomad-docker-image)
  - [Iteration of the Development Process](#iteration-of-the-development-process)
  - [Changelog](#changelog)
- [Test Configuration and Execution](#test-configuration-and-execution)
  - [Linters and formatting](#linters-and-formatting)
    - [Linters](#linters)
    - [Terraform formatting](#terraform-formatting)
  - [Testing the module](#testing-the-module)
- [If This Is in Your Own Repository](#if-this-is-in-your-own-repository)


## Description - What & Why
This template is a starting point, and example, on how to take advantage of the [Hashistack vagrant-box](https://app.vagrantup.com/fredrikhgrelland/boxes/hashistack) to create, develop, and test Terraform-modules within the Hashistack ecosystem.

**Hashistack**, in current repository context, is a set of software products by [HashiCorp](https://www.hashicorp.com/).


> :bulb: If you found this in `fredrikhgrelland/vagrant-hashistack`, you may be interested in the separate repository [vagrant-hashistack-template](https://github.com/fredrikhgrelland/vagrant-hashistack-template/).  
> :warning: If you are reading this in your own repository, go to [If This Is in Your Own Repository](#if-this-is-in-your-own-repository)

### Why Does This Exist?
 This template aims to standardize workflow for building and testing terraform-nomad-modules, using the [fredrikhgrelland/hashistack](https://github.com/fredrikhgrelland/vagrant-hashistack) vagrant-box.


### Services
The default box will start Nomad, Vault, Consul and MinIO bound to loopback and advertising on the IP `10.0.3.10`, which should be available on your local machine.
Port-forwarding for `nomad` on port `4646` should bind to `127.0.0.1` and should allow you to use the nomad binary to post jobs directly.
Consul and Vault have also been port-forwarded and are available on `127.0.0.1` on ports `8500` and `8200` respectively.
Minio is started on port `9000` and shares the `/vagrant` (your repo) from within the vagrant box.

|Service|URL|Token(s)|
|:---|:---:|:---:|
|Nomad| [http://10.0.3.10:4646](http://10.0.3.10:4646)||
|Consul| [http://10.0.3.10:8500](http://10.0.3.10:8500)|master|
|Vault| [http://10.0.3.10:8200](http://10.0.3.10:8200)|master|
|Minio| [http://10.0.3.10:9000](http://10.0.3.10:9000)|minioadmin : minioadmin|

#### Port collisions
If you get the error message
```text
Vagrant cannot forward the specified ports on this VM, since they
would collide with some other application that is already listening
on these ports. The forwarded port to 8500 is already in use
on the host machine.
```
you do most likely have another version of the vagrant-box already running and using the ports. You can solve this in one of two ways:

##### Option 1 Shut down the running machine
Run
```bash
vagrant status
```
to see all running boxes. Then run
```bash
vagrant destroy <box-name>
```
to take it down. [Doc on what `vagrant destroy` does](https://www.vagrantup.com/docs/cli/destroy).

##### Option 2 Use the `auto_correct` feature to dynamically allocate ports
Vagrant has a configuration option called [auto_correct](https://www.vagrantup.com/docs/networking/forwarded_ports#auto_correct) which will use another port if the port specified is already taken. To enable it you can add the lines below to the bottom of your `Vagrantfile`.
```hcl
Vagrant.configure("2") do |config|
    # Hashicorp consul ui
    config.vm.network "forwarded_port", guest: 8500, host: 8500, host_ip: "127.0.0.1", auto_correct: true
    # Hashicorp nomad ui
    config.vm.network "forwarded_port", guest: 4646, host: 4646, host_ip: "127.0.0.1", auto_correct: true
    # Hashicorp vault ui
    config.vm.network "forwarded_port", guest: 8200, host: 8200, host_ip: "127.0.0.1", auto_correct: true
end
```
This will enable the autocorrect-feature on the ports used by consul, nomad, and vault.

> :bulb: You can find out more about Vagrantfiles [here](https://www.vagrantup.com/docs/vagrantfile)

## Install Prerequisites

```text
make install
```

The command, will install:
- [VirtualBox](https://www.virtualbox.org/)
- [Packer](https://www.packer.io/)
- [Vagrant](https://www.vagrantup.com/) with additional plugins
- [Additional software dependent on the OS (Linux, MacOS)](../install/Makefile)

### Packages that needs to be pre-installed

- [Make](https://man7.org/linux/man-pages/man1/make.1.html)
- [Git CLI](https://git-scm.com/book/en/v2/Getting-Started-The-Command-Line)

#### MacOS Specific
- Virtualization must be enabled. [This is enabled by default on MacOS.](https://support.apple.com/en-us/HT203296)
- [Homebrew](https://brew.sh/) must be installed.

#### Ubuntu Specific
- Virtualization must be enabled. [Error if it is not.](https://github.com/fredrikhgrelland/vagrant-hashistack/issues/136)
- Packages [gpg](http://manpages.ubuntu.com/manpages/xenial/man1/gpg.1.html) and [apt](http://manpages.ubuntu.com/manpages/bionic/man8/apt.8.html) must be installed.

---

`NB` _Post installation you might need to reboot your system in order to start the virtual-provider (VirtualBox)_

---


## Configuration

### Startup Scheme
From a thousand foot view the startup scheme will:
1. Start the hashistack and MinIO
2. Run [playbook.yml](dev/ansible/playbook.yml), which in turn runs all ansible-playbooks inside [dev/ansible/](dev/ansible).

> :bulb: Vagrantfile lines 8-11 run the first playbook on startup, and can be changed.  
> :bulb: Below is a detailed description of the _whole_ startup procedure, both user changeable and not.

---

#### Detailed Startup Procedure
_box_ - Comes bundled with the box, not possible to change

_system_ - Provided by the system in automated processes, not possible to change

_user_ - Provided by the user to alter the box or template in some way

|Seq number| What | Provided by | Description |
|:--:|:------------|:------------:|:-----|
|1 |`/home/vagrant/.env_default`|[ _box_ ]| default variables |
|2 |`/vagrant/.env`|[ _user_ ]| variables override, see [Pre-packaged Configuration Switches](#pre-packaged-configuration-switches) for details |
|3 |`/vagrant/.env_override`|[ _system_ ]| variables are overridden for test purposes |
|4 |`/vagrant/dev/vagrant/conf/pre_ansible.sh`|[ _user_ ]| script running before ansible bootstrap procedure, [details](dev/vagrant/conf/pre_bootstrap/README.md) |
|5 |`/vagrant/dev/vagrant/conf/pre_bootstrap/*.yml`|[ _user_ ]| pre bootstrap tasks, running before hashistack software starts, [details](dev/vagrant/conf/README.md) |
|6 |`/etc/ansible/bootstrap.yml`|[ _box_ ]| verify ansible variables and software configuration, run hashistack software and MinIO, & verify that it started correctly,  [link](../ansible/bootstrap.yml) |
|7 |`/vagrant/conf/post_bootstrap/*.yml`|[ _user_ ]| poststart scripts, running after hashistack software has started, [details](dev/vagrant/conf/pre_bootstrap/README.md) |
|8 |`/vagrant/dev/conf/post_ansible.sh`|[ _user_ ]| script running after ansible bootstrap procedure, [details](dev/vagrant/conf/README.md) |
|9 |`/vagrant/ansible/*.yml`|[ _user_ ]| ansible tasks included in playbook, see [Pre-packaged Configuration Switches](#pre-packaged-configuration-switches) for details |

---

### Pre and Post Hashistack Startup Procedure
#### Ansible Playbooks Pre and Post Hashistack Startup
You may change the hashistack configuration or add additional pre and post steps to the ansible startup procedure to match your needs.
Detailed documentation in [dev/vagrant/conf/README.md](dev/vagrant/conf/README.md)

#### Bash Scripts Pre and Post Ansible Playbook
In addition to ansible playbooks, you can also add bash-scripts that will be run before and/or after the ansible provisioning step. This is useful for doing deeper changes to the box pertaining to your needs. Detailed documentation in [dev/vagrant/conf/README.md](dev/vagrant/conf/README.md)


### Pre-packaged Configuration Switches

The box comes [with a set of configuration switches controlled by env variables](https://github.com/fredrikhgrelland/vagrant-hashistack#configuration) to simplify testing of different scenarios and enable staged development efforts.
To change any of these values from their defaults, you may add the environment variable to [.env](dev/.env).

NB: All lowercase variables will automatically get a corresponding  `TF_VAR_` prepended variant for use directly in terraform. [Script](../.github/action/create-env.py)

#### Enterprise vs Open Source Software (OSS)
To use enterprise versions of the hashistack components set the software's corresponding Enterprise-variable to `true` (see below).

#### Nomad

| default   | environment variable  |  value  |
|:---------:|:----------------------|:-------:|
|           | nomad_enterprise      |  true   |
|     x     | nomad_enterprise      |  false  |
|           | nomad_acl             |  true   |
|     x     | nomad_acl             |  false  |

When ACLs are enabled in Nomad the bootstrap token will be available in vault under `secret/nomad/management-token` with the two key-value pairs `accessor-id` and `secret-id`. `secret-id` is the token itself. These can be accessed in several ways:
- From inside the vagrant box with `vault kv get secret/nomad-bootstrap-token`
- From local machine with `vagrant ssh -c vault kv get secret/nomad-bootstrap-token"`
- By going to vault's UI on `localhost:8200`, and signing in with the root token.

#### Consul

| default   | environment variable             |  value  |
|:---------:|:---------------------------------|:-------:|
|           | consul_enterprise                |  true   |
|     x     | consul_enterprise                |  false  |
|     x     | consul_acl                       |  true   |
|           | consul_acl                       |  false  |
|     x     | consul_acl_default_policy        |  allow  |
|           | consul_acl_default_policy        |  deny   |

##### Enterprise - Namespaces

[Consul namespaces](https://www.consul.io/docs/enterprise/namespaces) feature is available in enterprise version only.
The switches below will enable [consul_namespaces_test.yml](https://github.com/fredrikhgrelland/vagrant-hashistack/blob/master/ansible/tests/enterprise/consul_namespaces_test.yml)

```text
consul_enterprise=true
consul_acl=true
consul_acl_default_policy=deny
```

Consul will come up with two additional namespaces ["team1", "team2"] and *admin token for these namespaces.

> :warning: Admin tokens use [builtin policy - Namespace Management](https://www.consul.io/docs/security/acl/acl-system#builtin-policies) with scope=global.

References:
- [Consul namespaces documentation](https://www.consul.io/docs/enterprise/namespaces)
- [Consul http api documentation](https://www.consul.io/api-docs/namespaces)
- [Consul cli documentation](https://www.consul.io/commands/namespace)
- [Consul 1.7 - Namespaces: Simplifying Self-Service, Governance and Operations Across Teams](https://youtu.be/Ff6kLvKkJBE)

#### Vault

| default   | environment variable             |  value  |
|:---------:|:---------------------------------|:-------:|
|           | vault_enterprise                 |  true   |
|     x     | vault_enterprise                 |  false  |

##### Consul Secrets Engine

If `consul_acl_default_policy` has value `deny`, it will also enable [consul secrets engine](https://www.vaultproject.io/docs/secrets/consul) in vault.  
Ansible will provision additional custom roles (admin-team, dev-team), [policies](../ansible/templates/consul-policies) and tokens for test purpose with different access level.

How to generate token:
```text
# generate token for dev team member
vagrant ssh -c 'vault read consul/creds/dev-team'

# generate token for admin team member
vagrant ssh -c 'vault read consul/creds/admin-team'
```

> :bulb: Tokens can be used to access UI (different access level depends on policy attached to the token)

##### Vault PKI

| default   | environment variable             |  value  |
|:---------:|:---------------------------------|:-------:|
|     x     | vault_pki                        |  true   |
|           | vault_pki                        |  false  |

[Vault PKI](https://www.vaultproject.io/docs/secrets/pki) will be enabled at `/pki`. A role called `default` is available to issue certificates.
Issue certificates from terminal:
```bash
vault write pki/issue/default common_name="your_common_name"
```
or with the terraform resource [`vault_pki_secret_backend_cert](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_cert):
```hcl-terraform
resource "vault_pki_secret_backend_cert" "app" {
  backend = "pki"
  name = "default"

  common_name = "app.my.domain"
}
```

### Vagrant Box Resources
If you get the error message `Dimension memory exhausted on 1 node` or `Dimension CPU exhausted on 1 node`, you might want to increase resources dedicated to your vagrant-box.
To overwrite the default resource-configuration you can add the lines
```hcl
Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpu = 2
    end
end
```
to the bottom of your [Vagrantfile](Vagrantfile), and change `vb.memory` and `vb.cpu` to suit your needs. Any configuration in [Vagrantfile](Vagrantfile) will overwrite the defaults if there is any. [More configuration options](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html).

> :bulb: The defaults can be found in [Vagrantfile.default](Vagrantfile.default).

## Getting Started

### Goals of This Guide
The end goal of this guide is to create a **terraform module** that works seamlessly inside a **hashistack**
ecosystem.

> :bulb: **Hashistack**, in current repository context, is a set of software products by [HashiCorp](https://www.hashicorp.com/).

If our terraform module is going to work properly with the hashistack we obviously need to both develop and test it within that very ecosystem. In short requires a full setup of Vault, Consul, Nomad, Terraform, and many  other technologies. We solve that with [Vagrant](https://www.vagrantup.com/). Vagrant is a technology that allows us to   easily set up a virtual machine based on a pre-made vagrant-box that is created by code we write. In the repository    [vagrant-hashistack](https://github.com/fredrikhgrelland/vagrant-hashistack/) we have a set of code that produces the vagrant-box called `fredrikhgrelland/hashistack` which is availabe on the [Vagrant cloud](https://vagrantcloud.com /fredrikhgrelland/hashistack). To set up a virtual machine based on this box you can write `vagrant init fredrikhgrelland` then `ANSIBLE_ARGS='--extra-vars "local_test=true"' vagrant up`. The `ANSIBLE_ARGS='--extra-vars "local_test=truei'"` lets the box know we are running it locally. When this vagrant-box is finished setting up you will have a virtual machine running on your local machine with the hashistack fully set up and ready to go. Without Vagrant every user that wants to effectively develop modules would have had to set up and integrate all the technologies on their own computers.

 The template you found this README in is specificully built to make it as easy and quick as possible to make the aforementioned modules, and develop and test them within the vagrant-hashistack box. This guide aims to show you how to use this terraform modules. While building a terraform module using this template there are several steps you might want to take, listed below. The order is not random, but if you personally want to do it in another order, that is completely fine, and up to you. The most important part of this tutorial is that you get an introduction to what this template is, and how to use it. The steps we are going to walk through are as follows:

- Building a docker image
- Creating a nomad job that uses this image
- Creating the terraform module
- Making the nomad job more dynamic

### Vagrant box vs your local machine
It's important to note that your local machine and the running vagrant box (from now on called virtual machine) are two completely separate entities. The virtual machine is available at the IP `10.0.3.10` and our local machine is available at the IP `127.0.0.1` or alternatively `localhost`. To make things easier Consul, Nomad, and Vault all have been forwarded so that they are also available at `localhost`, in addition to the virtual machine's IP. MinIO has not been forwarded, and is only available at `10.0.3.10`.
Lastly, the virtual machine and local machine share the folder where the `Vagrantfile` lies, and will be mapped to `/vagrant` inside the virtual machine [ref](#synced-folder).

TODO: generate PNG
```mermaid
graph TD
  subgraph local machine
    subgraph "virtual machine (10.0.3.10)"
        Consul
        Nomad
        Vault
        vagrant["/vagrant"]
        MinIO
        Other[Other softwares installed]
    end
    localhost["localhost (127.0.0.1)"]
    pwd["/<path-to-vagrantfile>"]
  end
  %% links
  Consul-->localhost
  Nomad-->localhost
  Vault-->localhost
  vagrant-->pwd
```

### Interacting with Nomad, Vault and Consul
When a vagrant box is set up the virtual machine is available at the IP `10.0.3.10`, and Nomad, Vault, and Consul all listen to their default ports, which are `4646`, `8200`, and `8500` respectively. In other words, you can reach nomad on `10.0.3.10:4646`, vault on `10.0.3.10:8200` and consul on `10.0.3.10:8500`. For convenience sake these services have been port forwarded (as mentioned earlier), meaning they are also available at `localhost`, on the same ports; Nomad then becomes `localhost:4646`, Vault `localhost:8200`, and so on. Nomad, Vault and Consul have their own CLI-tools used to interact with the servers that are running, and they default to `localhost`, and the default ports just mentioned. This means you can download any of the binaries, and they will be connected to the services running inside the virtual machine right from the get-go. Refer to [this section](#iteration-of-the-development-process) to see examples on how to use this.

### Using ansible
When working with this box we will use a technology called [ansible](https://www.ansible.com/). In short, ansible is a software that logs onto a computer like a normal user, and performs tasks defined in an ansible playbook (example [template_example/dev/ansible/playbook.yml](template_example/dev/ansible/playbook.yml). We will mostly be using this to interact with our virtual machine. In our case _all_ playbooks put inside [dev/ansible/](./dev/ansible/) will be run every time we start the box, and we will utilise this throughout the guide.

### Making artifacts availabe inside the box
#### MinIO
The virtual machine has MinIO set up. The service is available at `10.0.3.10`. Anything put in MinIO will be available to the box using MinIO. See [pushing docker image](#pushing-resources-to-minio-with-ansible-docker-image) and [fetching docker image](#fetching-resources-from-minio-with-nomad-docker-image) for examples on how to make a docker image available inside the box. We will be using this later in the guide.

#### Synced folder
As mentioned earlier the virtual machine and local machine have a folder that's shared. The folder which the `Vagrantfile` lies in is linked to `/vagrant` inside the box.

### Your First Running Virtual Machine
As a first step, and to get to knowing the virtual machine a little, try running 
```bash
make up
```
in your terminal. This will start the provisioning of the virtual machine. It'll spew out a bunch of information and after a little while it's finished. Try going to `localhost:8500` in your browser, and you should see a consul UI. The same goes for Nomad and Vault if you go to their ports, `4646` and `8200`. Voila, you got your very own hashistack running. We have now verified what's in the section [Interacting with Nomad, Vault and Consul](#interacting-with-nomad-vault-and-consul). Next, let's log onto our virtual machine with
```bash
vagrant ssh
```
You are now inside the box. Let's go to our `/vagrant` folder and an `ls`. Do you notice that it contains exactly the same things as the folder this README is in? As mentioned in [Synced folder](#synced-folder) this is a synced folder, which will come in handy later. Try also running `terraform --help`, `nomad --help`, and `vault --help`, and you'll see that they are all available as CLI-tools inside your virtual machine.


### The development process

#### 1. Building Docker Image

> :warning: This section is only relevant if you want to build your own docker image. Skip this if you are new.
> :warning: If you are not very familiar with the process of building images, we recommend using a simple [nginx](https://hub.docker.com/_/nginx) container for now.  

Most of the terraform modules will deploy one or more docker-containers to Nomad. Many will want to create their own docker images for this. The template supplies a [docker/](/docker/) folder to do this.

To build your own docker image start by adding a file named [`Dockerfile`](https://docs.docker.com/engine/reference/builder/) to [docker/](/docker/). You can then test and develop this image like you would with any other `Dockerfile`. Try and build this like any other docker-image by running `docker build ./docker` to see that everything is working properly. At this point we've got a docker image on our local machine, but as mentioned earlier the virtual machine and local machine are not the same thing. We need to get it into the virtual machine somehow. To do that we are going to archive it and put it into MinIO, which is on the virtual machine. You can jump to the next section to see how that is done.

#### 2. Deploying Container With Nomad
At this point you should have a service that will run when you start the docker container. Either you've made a container yourself, or you are using the nginx container. The next step is then to somehow deploy this container to our hashistack ecosystem. To do that we will use Nomad. Nomad is running inside our virtual machine, and is used to deploy containers, and register them into consul. It also has tight integration with vault. 

##### Making image available to Nomad

> :warning: Skip this if you are using the nginx container

After successfully building the docker image we want to create a nomad-job that takes this image and deploys it and registers it with consul, so that we have a running service. In the end this is what we want our terraform module to do, but we'll first do this manually to make sure everything is working before we try and wrap a terraform module around it. The image we built in our first step is now available as an image on our local machine, but our vagrant box does not have access to that. For all intents and purposes our local machine and the vagrant box are two different machines. In other words we need to somehow take our docker image, and make that available inside our box (because that is where the nomad server is running). To be able to transfer files from our local machine to the vagrant box we are going to use MinIO which was mentioned earlier. You can upload files from the UI in your browser, or we have also set it up so that all files put in the same directory as this README will be copied into MinIO. [This section](#pushing-resources-to-minio-with-ansible-docker-image) shows how we can use ansible code to first create a tmp folder, then build and archive our docker image in that tmp folder. Because the tmp folder is in the same directory as this README it'll automatically now be available in MinIO. Lucky for us, Nomad then has a way to extract images from MinIO and use them.

##### Creating a nomad job
Next step is to create the nomad job that deploys our image. This guide will not focus on how to make a nomad job, but a full example can be found at [template_example/conf/nomad/countdash.hcl](template_example/conf/nomad/countdash.hcl). Your nomad job-file should go under `conf/nomad/`. If you made your own docker image see [fetching docker image](#fetching-resources-from-minio-with-nomad-docker-image) on how to use that in your nomad job. When the nomad job-file has been created we can try and run it. We can do this one of two ways:

- Log on the machine with `vagrant ssh` and run it with the nomad-cli inside the virtual machine. Remember that all files inside `/vagrant` are shared with the folder of this `README`, meaning you can go to `/vagrant/conf/nomad` to find your hcl-file. Then run it with `nomad job run <nameofhcl.hcl>`.  
- If you have the nomad-cli on your local machine you can run it with `nomad job run <nameofhcl.hcl>`. 

After sending the job to nomad you can check the status of it by going to `localhost:4646`. There you will see your job running.

#### 3. Creating the Terraform Module
A terraform module normally consists of a minimum of three files, `main.tf`, `variables.tf`, `outputs.tf`. Technically we only need one, but it's customary to include at least these three. `main.tf` contains the resources used, `variables.tf` contains all variables used, and `outputs.tf` defines any output variables (if relevant). All files should be put in the root (same as the folder this README is in). Our goal now is to create a terraform module that will take an HCL-file and deploy it to a given Nomad. 


##### main.tf
In our case the only thing our main.tf should contain is a resource that takes our nomad-job file and deploys it to Nomad. To be able to use a resource that does this, we need to supply a [nomad provider](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs), but we do not want to supply that with the module itself. We would rather that the place that is importing the module supplies it. When done this way it ensures that the module is not tied down to one single nomad-provider, but can be used in different configurations with different nomad-providers. Below is an example of how to take a nomad-job file and deploy it to Nomad:

```hcl-terraform
resource "nomad_job" "countdash" {
  jobspec = file("${path.module}/conf/nomad/countdash.hcl")
  detach  = false
}
```

`${path.module}` is the path to where our module is. `detach = false` tells terraform to wait for the service to be healthy in nomad before finishing. 


##### variables.tf

> :warning: In our first iteration of our terraform-module we don't need any input variables.

In this file you define any variables you would want to be input variables to your module. If we are provisioning a postgres service, maybe we'd like a "Name of postgres database" variable as input, or "Number of servers to provision" if you are provisioning a cluster.  A variable is defined like below:

```hcl-terraform
variable "service_name" {
  type        = string
  description = "Minio service name"
  default     = "minio"
}
```

##### outputs.tf

> :warning: In our first iteration of our terraform-module we don't need any output variables.

This files contains variables that will be available as outputs when you use a module. Below is first an example of
how to define output-variables, then an example of how to use a module, and access their output variables.
Defining output variables:

 ```hcl-terraform
output "nomad_job" {
  value       = nomad_job.countdash
  description = "The countdash nomad job object"
}
```

> :bulb: Together inputs and outputs should create a very clear picture of how a module should be used. For example in our hive module we have clearly defined that it needs to have a postgres-address as an input. In our postgres module we have an output that is exactly that. In other words, we might need to import and setup a postgres-module before setting up our hive-module, so that we get a postgres-address to give our hive-module. Or, if we already have a postgres-address available, we could supply that instead. The goal is to clearly define the needs of a module, while at the same time making it flexible and generic (in the example of hive we give the user the ability to use any postgres they'd like). How to use variables and outputs will be shown later in [make the module more dynamic]().

#### 4. Using a Terraform Module
At this point we have created three files (or one), `main.tf`, `variables.tf` and `outputs.tf`. Together they do one thing, which is start a nomad job. So in theory, we are done with our goal; create a terraform module. Almost. We still need to verify that it works the way we expect it to. What we now want to do is write some terraform code that runs the module we have now made, then run that code on our virtual machine. We will do this in two steps, first we will write the code that uses the module, go into the box and run the code manually, and lastly, write some ansible code that runs it automatically. The next lines of terraform code should be put in a `main.tf` under `example/` because this will be an example of how to use the module.

Below is an example on how to use a module:

 ```hcl-terraform
module "whatever" {
  source      = "github.com/fredrikhgrelland/terraform-nomad-minio.git?ref=0.0.3"
}
```

This will fetch the module at the given source, in the case above it is a MinIO module, version 0.0.3. 

Create a file called `main.tf` under the `example/` directory, and add the code above, change the module's name, and source. The source is `../` in this case because that is where our module files are, relative to the `main.tf` you are writing this in. 

Let's log onto our virtual machine and try and run it! Run `vagrant ssh` if needed, and navigate to your `/vagrant/example/` folder. Next run `terraform init` to initialize a terraform-workspace. When that is done you can try `terraform plan`, which will read your terraform code and attempt to make a runtime plan. When doing so you will get the error "Error: Missing required argument The argument "address" is required, but was not set.". This is because we are using a resource that deploys a nomad job, but nowhere in our terraform files have we defined _ what_ Nomad to use. At the moment no Nomad is known. This is where [providers]() come into the picture. They are providers for the resources we are using, and in our case we need to define a [Nomad provider](). We could do this in either of our `main.tf` files, but if we do it in our module's `main.tf` it will be very difficult for anyone to use our module, because the Nomad's address is predefined. Instead we should include what nomad to use in our example´s `main.tf`, which is simply an example of how to use the module, meaning anyone else wanting to use the module could supply their own nomad when using the module. To supply a provider add the lines below to your `example/main.tf` file:

```hcl-terraform
provider "nomad" {
  address = "http://127.0.0.1:4646"
}
```

we have now told terraform what Nomad we want to use. Try running your terraform code with `terraform init` (we need to load the nomad provider), `terraform plan` (this time it should succeed), then lastly `terraform apply`, which will execute the plan. Go to `localhost:4646` to check if the nomad-job has started running, if it has, congratulations, you have made your first working terraform module!



#### 5. Using Ansible To Run the Code in the Previous Step On Startup
Way earlier I mentioned that ALL ansible tasks put inside `dev/ansible/` will be run when the box starts. We can use this to automatically start our module when we run `make up`. The ansible code for running terraform code is below. Add this to `run-terraform.yml` or another aptly named file.

```yml
- name: Terraform
  terraform:
    project_path: ../../example
    force_init: true
    state: present
  register: terraform

- name: Terraform stdout
  debug:
    msg: "{{terraform.stdout}}"
```


#### 6. Making The Nomad Job More Dynamic With Terraform Variables

#### 7. Integrating The Nomad Job With Vault


#### Github Workflows

## Usage
### Commands
There are several commands that help to run the vagrant-box:
- `make install` installs all prerequisites. Run once.

- `make up` provisions a [vagrant-hashistack](https://github.com/fredrikhgrelland/vagrant-hashistack/) box on your machine. After the machine and hashistack are set up it will run the [Startup Scheme](#startup-scheme).

- `make clean` takes down the provisioned box if there is any.

- `make dev` is same as `make up` except that it skips all the tasks within ansible playbook that have the tag `test` and custom_ca. Read more about ansible tags [here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html).

- `make test`  takes down the provisioned box if there is any, removes tmp files and then runs `make up`.

- `make update` downloads the newest version of the [vagrant-hashistack box](https://github.com/fredrikhgrelland/vagrant-hashistack/) from [vagrantcloud](https://vagrantcloud.com/fredrikhgrelland/hashistack).

- `make template_example` runs the example in [template_example/](template_example).

- `make pre-commit` this is a helper command that will run the github linter locally and formatt/prettify all the `.tf` files in the directory.

> :bulb: For full info, check [`template/Makefile`](./Makefile).
> :warning: Makefile commands are not idempotent in the context of vagrant-box.  You could face the error of port collisions. Most of the cases it could happen because of the vagrant box has already been running. Run `vagrant destroy -f` to destroy the box.

Once vagrant-box is running, you can use other [options like the Nomad- and Terraform-CLIs to iterate over the deployment in the development stage](#iteration-of-the-development-process).

### MinIO
Minio S3 can be used as a general artifact repository while building and testing within the scope of the vagrantbox to push, pull and store resources for further deployments.

> :warning: Directory `/vagrant` is mounted to minio. Only first level of sub-directories become bucket names.

Resource examples:
- docker images
- compiled binaries
- jar files
- etc...

#### Pushing Resources To MinIO With Ansible (Docker image)
Push(archive) of docker image.
```yaml
# NB! Folder /vagrant is mounted to Minio
# Folder `dev` is going to be a bucket name
- name: Create tmp if it does not exist
  file:
    path: /vagrant/dev/tmp
    state: directory
    mode: '0755'
    owner: vagrant
    group: vagrant

- name: Archive docker image
  docker_image:
    name: docker_image
    tag: local
    archive_path: /vagrant/dev/tmp/docker_image.tar
    source: local
```
[Full example](template_example/dev/ansible/01_build_docker_image.yml)

#### Fetching Resources From MinIO With Nomad (Docker image)
> :bulb: [The artifact stanza](https://www.nomadproject.io/docs/job-specification/artifact) instructs Nomad to fetch and unpack a remote resource, such as a file, tarball, or binary.

Example:
```hcl
task "web" {
  driver = "docker"
  artifact {
    source = "s3::http://127.0.0.1:9000/dev/tmp/docker_image.tar"
    options {
      aws_access_key_id     = "minioadmin"
      aws_access_key_secret = "minioadmin"
    }
  }
  config {
    load = "docker_image.tar"
    image = "docker_image:local"
  }
}
```
[Full example](./template_example/conf/nomad/countdash.hcl)

### Iteration of the Development Process

Once you start the box with one of the commands `make dev`, `make up` or `make example`,
you need a simple way how to continuously deploy development changes.

There are several options:

1. **From the local machine**. You can install Hashicorp binaries on the local machine, such as terraform and nomad.
Then you can deploy changes to the vagrant-box using these binaries.

Example terraform:
```text
terraform init
terraform apply
```

Example nomad:
```text
nomad job run countdash.hcl
```

> :warning: _Your local binaries and the binaries in the box might not be the same versions, and may behave differently. [Box versions.](../ansible/group_vars/all/variables.yml)

2. **Using vagrant**. Box instance has all binaries are installed and available in the PATH.
You can use `vagrant ssh` to place yourself inside of the vagrantbox and run commands.

```text
# remote command execution
vagrant ssh default -c 'cd /vagrant; terraform init; terraform apply'

# ssh inside the box, local command execution
vagrant ssh default
cd /vagrant
terraform init
terraform apply
```

> :bulb: `default` is the name of running VM. You could also use VM `id`.
To get vm `id` check `vagrant global-status`.

### Changelog
The CHANGELOG.md should follow this [syntax](https://keepachangelog.com/en/1.0.0/).

## Test Configuration and Execution

### Linters and formatting
#### Linters
All PRs will run [super-linter](https://github.com/github/super-linter). You can use [this](https://github.com/github/super-linter/blob/master/docs/run-linter-locally.md) to run it locally before creating a PR.
> :bulb: Information about rules can be found under [.github/linters/](.github/linters)

#### Terraform formatting
You can run [`terraform fmt --recursive`](https://www.terraform.io/docs/commands/fmt.html) to rewrite your terraform config-files to a [canonical format](https://www.terraform.io/docs/configuration/style.html).
> :warning: [Terraform binary](https://www.terraform.io/downloads.html) must be available to do this.

### Testing the module
The tests are run using [Github Actions](https://github.com/features/actions) feature which makes it possible to automate, customize, and execute the software development workflows right in the repository. We utilize the **matrix testing strategy** to cover all the possible and logical combinations of the different properties and values that the components support. The .env_override file is used by the tests to override the values that are available in the .env_default file, as well as the user configurable .env file.


As of today, the following tests are executed:

| Test name                                                                                  | Consul Acl  |  Consul Acl Policy  |  Nomad Acl    | Hashicorp binary
|:------------------------------------------------------------------------------------------:|:------------|:-------------------:|:-------------:|:---------------:|
|    test (consul_acl_enabled, consul_acl_deny, nomad_acl_enabled, hashicorp_oss)            |  true       |  deny               |  true         | Open source     |
|    test (consul_acl_enabled, consul_acl_deny, nomad_acl_enabled, hashicorp_enterprise)     |  true       |  deny               |  true         | enterprise      |
|    test (consul_acl_enabled, consul_acl_deny, nomad_acl_disabled, hashicorp_oss)           |  true       |  deny               |  false        | Open source     |
|    test (consul_acl_enabled, consul_acl_deny, nomad_acl_disabled, hashicorp_enterprise)    |  true       |  deny               |  false        | enterprise      |
|    test (consul_acl_disabled, consul_acl_deny, nomad_acl_enabled, hashicorp_oss)           |  false      |  deny               |  true         | Open source     |
|    test (consul_acl_disabled, consul_acl_deny, nomad_acl_enabled, hashicorp_enterprise)    |  false      |  deny               |  true         | enterprise      |
|    test (consul_acl_disabled, consul_acl_deny, nomad_acl_disabled, hashicorp_oss)          |  false      |  deny               |  false        | Open source     |
|    test (consul_acl_disabled, consul_acl_deny, nomad_acl_disabled, hashicorp_enterprise)   |  false      |  deny               |  false        | enterprise      |

The latest test results can be looked up under the **Actions** tab.

## If This Is in Your Own Repository
If you are reading this from your own repository you should _delete_ this `README.md`, fill out `README_template.md`, and rename `README_template.md` to `README.md`.
