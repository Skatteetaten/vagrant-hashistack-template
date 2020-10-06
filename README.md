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
  - [Building Docker Image](#building-docker-image)
  - [Deploying Container With Nomad](#deploying-container-with-nomad)
    - [Making image available to Nomad](#making-image-available-to-nomad)
    - [Creating a nomad job](#creating-a-nomad-job)
  - [Creating the Terraform Module](#creating-the-terraform-module)
    - [main.tf](#maintf)
    - [variables.tf](#variablestf)
    - [outputs.tf](#outputstf)
  - [Using Terraform Module With Ansible](#using-terraform-module-with-ansible)
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
- [Additional software dependent on the OS (Linux, MacOS)](https://github.com/fredrikhgrelland/vagrant-hashistack/blob/master/install/Makefile)

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
|6 |`/etc/ansible/bootstrap.yml`|[ _box_ ]| verify ansible variables and software configuration, run hashistack software and MinIO, & verify that it started correctly,  [link](https://github.com/fredrikhgrelland/vagrant-hashistack/blob/master/ansible/bootstrap.yml) |
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

NB: All lowercase variables will automatically get a corresponding  `TF_VAR_` prepended variant for use directly in terraform. [Script](/.github/action/create-env.py)

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

#### Vault

| default   | environment variable             |  value  |
|:---------:|:---------------------------------|:-------:|
|           | vault_enterprise                 |  true   |
|     x     | vault_enterprise                 |  false  |

##### Consul Secrets Engine

If `consul_acl_default_policy` has value `deny`, it will also enable [consul secrets engine](https://www.vaultproject.io/docs/secrets/consul) in vault.  
Ansible will provision additional custom roles (admin-team, dev-team), [policies](https://github.com/fredrikhgrelland/vagrant-hashistack/tree/master/ansible/templates/consul-policies) and tokens for test purpose with different access level.

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
- Expanding nomad job so that it uses vault
- Creating the terraform module
- making the nomad job more dynamic

### Vagrant box vs your local machine
It's important to note that your local machine, and the running vagrant box (from now on called virtual machine) are two completely separate entitites. In our case Consul, Nomad, and Vault have all been forwarded so they are also avaialble at localhost, in addition to the virtual machine's IP (see below). MinIO has not been forwarded, and is only available at 10.0.3.10.
Lastly, the virtual machine and local machine share the folder where the `Vagrantfile` lies, and will be mapped to `/vagrant` inside the virtual machine.
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

### Building Docker Image
> :warning: This section is only relevant if you want to build your own docker image.

 Most of the terraform modules will deploy one or more docker-containers to Nomad. Many will want to create their own docker images for this. The template supplies a [docker/](/docker/) folder to do this.

To build your own docker image start by adding a file named [`Dockerfile`](https://docs.docker.com/engine/reference/builder/) to [docker/](/docker/). You can then test and develop this image like you would with any other `Dockerfile`. Try and build this like any other docker-image by running `docker build ./docker` to see that everything is working properly. At this point we've got a docker image on our local machine, but as mentioned earlier the virtual machine and local machine are not the same thing. In other words, we need to get it into the virtual machine somehow. To do that we are going to archive it and put it into MinIO, which is on the virtual machine. You can jump to the next section to see how that is done.

### Deploying Container With Nomad
#### Making image available to Nomad
After successfully building the docker image we want to create a nomad-job that takes this image and deploys it and registers it with consul, so that we have a running service. In the end this is what we want our terraform module to do, but we'll first do this manually to make sure everything is working before we try and wrap a terraform module around it. The image we built in our first step is now available as an image on our local machine, but our vagrant box does not have access to that. For all intents and purposes our local machine and the vagrant box are two different machines. In other words we need to somehow take our docker image, and make that available inside our box (because that is where the nomad service is running). To be able to transfer files from our local machine to the vagrant box we have set up a S3 storage solution called MinIO, that is available from our local machine at `http://10.0.3.10:9000`. You can think of it as a google drive. You can upload files from the UI in your browser, or we have also set it up so that all files put in the same directory as this README will be copied into MinIO. [This section](#pushing-resources-to-minio-with-ansible-docker-image) shows how we can use ansible code to first create a tmp folder, then build and archive our docker image in that tmp folder. Because the tmp folder is in the same directory as this readme it'll automatically now be available in MinIO. Lucky for us, nomad then has a way to extract images from MinIO and use them.

#### Creating a nomad job
Next step is to create the nomad job that deploys our image. This guide will not focus on how to make a nomad job, but a full example can be found at [template_example/conf/nomad/coundash.hcl](template_example/conf/nomad/coundash.hcl). To see how you can use the docker image we created in the previous step, see [this section](#fetching-resources-from-minio-with-nomad-docker-image). When the nomad job has been created we can try and run it. You can either log on the machine with vagrant ssh or run it locally from your computer with nomad job run nameofhcl.hcl. When you know that your container and nomad job is working as expected its time to wrap a terraform module around this, so that it is possible to import and run the terraform module, which will then start the whole service (which in this case is basically starting deploying the nomad job).

### Creating the Terraform Module
 A terraform module consists of a minimum of three files, main.tf, variables.tf, outputs.tf. main.tf contains the
 providers and resources used, variables.tf contains all variables used, and outputs.tf defines any output variables (if relevant). At this point we will create the terraform module itself, then we will use ansible to import it into our box, and try and use it in our hashistack ecosystem.

Just to sketch out what we want: the module itself should contain the resources that sets up a job in nomad. See [example](template_example/main.tf). We should then be able to write some terraform code that then imports this module and uses it.

#### main.tf
In our case the only thing our main.tf should contain is a resource that takes our nomad-job file and deploys it to nomad. To be able to use a resource that does this, we need to supply a [nomad provider](), but we do not want to supply that with the module itself. We would rather that the place that is importing the module supplies this. When done this way it ensures that the module is not tied down to one single nomad-provider, but can be used in different configurations with different nomad-providers. Below is an example of the commonly used resource `nomad-job`, that would reside within `main.tf`.
    
```hcl-terraform
resource "nomad_job" "countdash" {
  jobspec = file("${path.module}/conf/nomad/countdash.hcl")
  detach  = false
}
```

#### variables.tf
In this file you define any variables you would want to be input variables to your module. An example could be "Name of your postgres database" if we are talking about a module that provisions a postgres database, or "Number of servers to provision" if you are provisioning a cluster of something. A variable is defined like below

```hcl-terraform
variable "service_name" {
  type        = string
  description = "Minio service name"
  default     = "minio"
}
```

#### outputs.tf
This files contains variables that will be available as outputs when you use a module. Below is first an example of
 how to define output-variables, then an example of how to use a module, and access their output variables.
 Defining output variables
 ```hcl-terraform
output "nomad_job" {
  value       = nomad_job.countdash
  description = "The countdash nomad job object"
}
```

Using a module and accessing its output variables
 ```hcl
module "postgres" {
  source = "github.com/fredrikhgrelland/terraform-nomad-postgres.git?ref=0.0.1"
}
```

Using a previously defined module to accesss its output variables
 ```hcl
resource "some other resource"{
  outputvariable = module.postgres.outputvariable
}
```

Together inputs and outputs should create a very clear picture of how a module should be used. For example in our hive module we have clearly defined that the module needs to have a postgres-address as an input. Looking at our postgres module, it has an output that is exactly that. In other words, we might need to import and setup a postgres-module before setting up our hive-module. Or, if we already have a postgres-address available, we could supply that instead. The goal is to clearly define the needs of a module, while at the same time making it flexible and generic (in the example of hive we give the user the ability to use any postgres they'd like).

### Using Terraform Module With Ansible

## Usage
### Commands
There are several commands that help to run the vagrant-box:
- `make install` installs all prerequisites. Run once.

- `make up` provisions a [vagrant-hashistack](https://github.com/fredrikhgrelland/vagrant-hashistack/) box on your machine. After the machine and hashistack are set up it will run the [Startup Scheme](#startup-scheme).

- `make clean` takes down the provisioned box if there is any.

- `make dev` is same as `make up` except that it skips all the tasks within ansible playbook that have the tag `test` and custom_ca. Read more about ansible tags [here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html).

- `make test`  takes down the provisioned box if there is any, removes tmp files and then runs `make up`.

- `make update` downloads the newest version of the [vagrant-hashistack box](https://github.com/fredrikhgrelland/vagrant-hashistack/) from [vagrantcloud](https://vagrantcloud.com/fredrikhgrelland/hashistack).

- `make template_example` runs the example in [template_example/](template_example)

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
