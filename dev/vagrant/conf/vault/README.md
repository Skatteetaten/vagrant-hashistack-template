# Vault configuration 
You may add any hcl-files to this directory in order to change or override the configuration.
Any valid [vault configuration](https://www.vaultproject.io/docs/configuration) added to this directory will append to the configuration, in lexical order. 
It means that by adding the file `00-override.hcl` will be read first and the file `99-override.hcl` you will ensure it will be read last.

An example file is provided in [template_example/dev/vagrant/conf/vault](https://github.com/fredrikhgrelland/vagrant-hashistack-template/tree/master/template_example/dev/vagrant/conf/vault).
