# Tutorials
Here you can find hands-on tutorials and tips for working with Github and the Vagrant box.

## Content
1. [How to release](#how-to-release-video)
2. [How to test in vagrant box](#how-to-test-in-vagrant-box-video)
3. [How to clean up box](#how-to-clean-up-box-video)

## How to release [VIDEO]
The release process is pretty simple. The only thing you have to do is to create a new branch (e.g. `release_0.3.0`),
and remove the tag `UNRELEASED` in the CHANGELOG.md file.
When creating the pull request you need to lable it with `major`, `minor`, or `patch`, according to your release.
See the video bellow for a full walk through:

[release  **[duration: 1m 36s]**](https://youtu.be/6OHKloM-rL4)

## How to test inside vagrant box [VIDEO]
After you run either `make dev/up/test`, you can ssh into the box and stop/run jobs.
Say that your module failed after running `make up` and you want to re-run the terraform job.

First, ssh into the box and cd to the `/vagrant` folder:
```sh
vagrant ssh
cd /vagrant
```
Then purge your Nomad job:
```sh
nomad job stop -purge <job-name>
````
You can now re-run your tasks using the `ansible-playbook` CLI.
```sh
ansible-playbook dev/ansible/playbook.yml
```

The following video shows a more thorough walk through:

[vagrantbox **[duration: 1m 32s]**](https://youtu.be/NrgmpUjTdRE)

## How to clean up box [VIDEO]
There are several ways to perform clean up.

You can clean up using `make clean`:

[make clean **[duration: 0m 18s]**](https://youtu.be/Qh175wWP6F8)

You can also manually remove boxes using `Oracle VM`:

[virtualbox **[duration: 0m 28s]**](https://youtu.be/8DbcfoIdbtg)
