# Ansible
This is a folder where you can run a series of sequential steps in the vagrant box. 

There is two things to note:
- The playbooks will run in a specific sequence (in alphanumeric order). We use numbers as a prefix to make order explicit, where numbered `00-<name>.yml` will run first and `99-<name>.yml` run last.
- Since [`playbook.yml`](playbook.yml) contains the main structure, all additional playbooks only need to include pure Ansible task syntax as seen bellow.

```yaml
- name: Descriptive task name
  debug:
    msg: This is a task
    
In the provided example, found in [template_example/dev/ansible](https://github.com/fredrikhgrelland/vagrant-hashistack-template/tree/master/template_example/dev/ansible), 
In the example, we use ansible to initialize and start a terraform job which in turn starts nomad jobs in parallel.		 we use Ansible-playbooks to create consul intentions, build a docker image, initialize and start a terraform job which in turn starts Nomad jobs in parallel, and perform healthchecks for our Nomad jobs.
