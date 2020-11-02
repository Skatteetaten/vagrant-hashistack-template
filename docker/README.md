# Docker build directory
Put your Dockerfile and other files relating to a docker-build here.

## Building docker image locally
If you have docker installed on your machine, you may want to build the image locally:
```sh
docker build -t my_image:local .
```

This image can be built and operated behind a corporate proxy where the base os needs to trust a custom CA.
While building locally using the Makefile, you may set the environment variable CUSTOM_CA to a custom `.crt` or `.pem` file in order to import it into the docker image. 
See [conf/certificates](conf/certificates).

Furthermore, you can take a look at the example in [template_example/docker/Dockerfile](https://github.com/fredrikhgrelland/vagrant-hashistack-template/blob/master/template_example/docker/Dockerfile) 
on how to import and trust CA for centos/debian/alpine based docker images.

## Building and testing the docker-image within the vagrant-hashistack box
We advise you to build and test your docker image within the hashistack eco-system. 
Running `make test` will launch the [default playbook](../dev/ansible/playbook.yml) inside the box, 
and the [template_example](https://github.com/fredrikhgrelland/vagrant-hashistack-template/blob/master/template_example/) shows a simple build process for building and running the docker image using this. 
Refer to ansible playbooks in [template_example/dev/ansible](https://github.com/fredrikhgrelland/vagrant-hashistack-template/tree/master/template_example/dev/ansible) to see details.
