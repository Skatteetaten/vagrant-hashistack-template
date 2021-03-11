# Consul configuration
You may add any `.hcl` or `.json` -files to this directory in order to change or override the configuration.
Any valid [consul configuration](https://www.consul.io/docs/agent/options.html#configuration_files) added to this directory will append the configuration, in lexical order.

An example file is provided in [template_example/dev/vagrant/conf/consul](https://github.com/fredrikhgrelland/vagrant-hashistack-template/tree/master/template_example/dev/vagrant/conf/consul).
It means that by prefixing a filename with `00` (e.g. `00-override.hcl`), it will be read first and using `99` (e.g. `99-override.hcl`) it will be read last.
