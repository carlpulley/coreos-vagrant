Basic setup:
* first generate a new discovery token (and add it to `config.rb`):
  * `curl https://discovery.etcd.io/new`
* launch two Lift nodes:
  * `INSTANCE=1,2 CLOUD_CONFIG=lift/akka METADATA="type=lift" vagrant up`
* launch a Cassandra node:
  * `INSTANCE=3 CLOUD_CONFIG=lift/cassandra METADATA="type=cassandra" vagrant up`

Sanity checking compute nodes:
* SSH into the `core-01` compute node:
  * `vagrant ssh core-01 -- -A` (you will need to ensure Vagrant SSH keys are setup)
* check which compute nodes are present (along with their metadata tags):
  * `fleetctl list-machines`
* check that Fleet service scripts have been installed:
  * `fleetctl list-unit-files`
* check that all (expected) Docker Lift images have been downloaded:
  * `docker images`

Checking of Cassandra node:
* boot a Cassandra container:
  * `fleetctl start cassandra@1.service`
* check status of Cassandra:
  * `fleetctl status cassandra@1.service`
* check that Cassandra booted correctly:
  * `fleetctl journal cassandra@1.service`
  * `journalctl` (for general service starting failures)
* check Cassandra logging:
  * `fleetctl ssh cassandra@1.service`
  * `docker logs cassandra-1`

Checking of Akka cluster nodes:
* launch 1 notification, profile and exercise micro-service:
  * `fleetctl start notification@1.service profile@1.service exercise@1.service`
* check that services have been launched:
  * `fleetctl list-units`
  * `fleetctl list-unit-files`
* view Akka cluster logging for a container (e.g. exercise):
  * `fleetctl ssh exercise@1.service`
  * `docker logs exercise-1`

Cluster formation:
* wait until cluster actor systems have registered:
  * `etcdctl ls /akka.cluster.nodes` should return at least one member (e.g. /akka.cluster.nodes/10.42.0.1:45678)
* specify an initial seed node (e.g. 10.42.0.1:45678) and form a cluster:
  * `fleetctl start seed@10.42.0.1:45678.service`
* verify cluster formation:
  * `fleetctl ssh exercise@1.service`
  * `docker logs exercise-1`
