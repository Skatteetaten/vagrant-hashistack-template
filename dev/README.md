# Dev
This directory contains code related to building, testing and developing in the vagrant box. The code is organized in two separate folders and a `.env` file.
See the following folders' READMEs to learn more:
- [ansible](ansible/README.md)
- [vagrant](vagrant/README.md)

The `.env` file on the other hand is used to override the default box environment variables. More information in [Pre-packaged Configuration Switches](../README.md#pre-packaged-configuration-switches)
The default values can be found in the [vagrant-hashistack/ansible/templates/.env_default.j2](https://github.com/fredrikhgrelland/vagrant-hashistack/blob/master/ansible/templates/.env_default.j2), 
and an example usage can be found in [template_example/.env](https://github.com/fredrikhgrelland/vagrant-hashistack-template/blob/master/template_example/.env).
 
