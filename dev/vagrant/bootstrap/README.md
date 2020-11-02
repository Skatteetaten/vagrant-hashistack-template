# Bootstrap 
In this folder you can customize the startup procedure of the Hashistack with pre- and post start ansible scripts.

You may put any number of playbooks in this directory for running ansible commands prior to bootstrapping the hashistack. 
Doing this, you need to provide the same folder structure as in the provided example found in [template_example/dev/vagrant/bootstrap](https://github.com/fredrikhgrelland/vagrant-hashistack-template/tree/master/template_example/dev/vagrant/bootstrap).

## :warning: Note
There is two things to note in the example:
- The playbooks in the example are numbered to run in a specific sequence (alphanumeric order), where numbered `00-<name>.yml` will run first and `99-<name>.yml` run last.
- All additional playbooks only need to include pure Ansible task syntax as seen bellow.

```yaml
- name: Descriptive task name
  debug:
    msg: This is a task
```

## Pre
You may add a `pre_ansible.sh` script file to this directory to run any alterations **before** ansible bootstrap procedure will run.

This might come handy if you need to change or replace that bootstrap process. For example you replacing the entire `/etc/ansible` directory.

## Post
If you need to run additional commands after ansible bootstrap has happened, you may add a `post_ansible.sh`.
This might come in handy if you would like to test a recent configuration change before anything you might add to your own Vagrantfile.
