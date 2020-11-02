# Vagrant 
In this directory you can override and/or create configurations for the Hashistack Vagrant box services (vault, consul, nomad).

There are two layers of configuration built into the box - the [*inner layer*](#inner-layer--easy-) and [*outer layer*](#outer-layer--advanced-).

## Inner layer ( easy )
The inner layer is the procedure where you can override the hashistack configurations. 
See the the README in the [conf](conf) folder for more information.

## Outer layer ( advanced )
The outer layer is where you can customize `pre-` and `post` startup procedures of the services (vault, consul, nomad) using Ansible scripts.
See the the README in [bootstrap](bootstrap) folder for more information.
