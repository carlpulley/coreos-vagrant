# Distributed Microservice Framework for CoreOS

This is an example (modular) framework for deploying distributed [microservice](http://martinfowler.com/articles/microservices.html)
applications:
* cluster compute nodes are instances of [CoreOS](https://coreos.com/) and are provisioned using [cloud-config](https://coreos.com/docs/cluster-management/setup/cloudinit-cloud-config/) files
* all microservices run within [docker](https://www.docker.com/) containers
* [etcd](https://coreos.com/using-coreos/etcd/) is used for service discovery
* [fleetctl](https://coreos.com/docs/launching-containers/launching/fleet-using-the-client/) is used to implement [systemd](http://www.freedesktop.org/software/systemd/man/systemd.unit.html) units for generally controlling services
* finally, [vulcand](https://github.com/mailgun/vulcand) is used as the load balancer (thus allowing the outside world to interact with our microservice REST APIs).

Example deployment implementations that utilise this framework are present on the following branches:
* `helloworld`
    * this branch implements deployment for a distributed "Hello World" style application - see its [README](https://github.com/carlpulley/coreos-vagrant/blob/helloworld/README.md) for more information.
* `lift`
    * this branch implements deployment for (most) of the [Lift](https://github.com/eigengo/lift) application by Jan Machacek - see its [README](https://github.com/carlpulley/coreos-vagrant/blob/lift/README.md) for more information.
