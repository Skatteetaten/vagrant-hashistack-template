# Nomad configuration 
You may add any `.hcl` or `.json` -files to this directory in order to change or override the configuration.
Any valid [nomad configuration](https://www.nomadproject.io/docs/configuration#general-parameters) added to this directory will append to the configuration, in lexical order. 
It means that by prefixing a filename with `00` (e.g. `00-override.hcl`), it will be read first and using `99` (e.g. `99-override.hcl`) it will be read last.

## Example `98-template-plugin.hcl`
```hcl
client {
  template {
    #Remove blacklist in order for allow "plugins" to run. We need curl to run as a plugin in template
    plugin_blacklist = []
  }
}
```

An example file is provided in [template_example/dev/vagrant/conf/nomad](https://github.com/fredrikhgrelland/vagrant-hashistack-template/tree/master/template_example/dev/vagrant/conf/nomad).
