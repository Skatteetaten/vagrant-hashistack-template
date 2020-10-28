# Vagrant 
In this directory, you can override and/or create a new configuration for the Hashistack Vagrant box services (vault, consul, nomad).

There are two layers of configuration built into the box - the [*inner layer*](#inner-layer--easy-) and [*outer layer*](#outer-layer--advanced-).

## Inner layer ( easy )
The inner layer is the procedure where you can override the hashistack configurations. 
See the the README in the [conf](conf) folder for more information.

## Outer layer ( advanced )
The outer layer is where you can customize the startup procedure of the Hashistack with pre- and post start Ansible scripts.
See the the README in [bootstrap](bootstrap) folder for more information.
