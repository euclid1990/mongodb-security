# MongoDB Security

## Topics

### Authentication

Authentication mechanisms and methods, configuring MongoDB authentication

### Authorization and Encryption

MongoDB's authorization model, creating users and roles, enabling encryption at rest and in transit.

### Auditing and Best Practices

Auditing with MongoDB, best practice checklists

## Install Evironment

We are using Vagrant as our environment for all examples.

- Install [Virtualbox](https://www.google.com.vn/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=mvc%20la%20gi)
- Install [Vagrant](https://www.vagrantup.com/downloads.html)
- Install [VirtualBox Guest Additions](https://github.com/dotless-de/vagrant-vbguest)
    ```sh
    $ vagrant plugin install vagrant-vbguest
    ```

## Spin up

```sh
$ cd /path/to/project
$ vagrant ssh database
```
