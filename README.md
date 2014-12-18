Basic setup:
* launch two 'Hello World' nodes:
  * `INSTANCE=1,2 CLOUD_CONFIG=helloworld/akka METADATA="akka=true" vagrant up`
* launch a Cassandra node:
  * `INSTANCE=3 CLOUD_CONFIG=cassandra METADATA="cassandra=true" vagrant up`

Sanity checking compute nodes:
* add insecure Vagrant SSH keys:
  * `ssh-add ~/.vagrant.d/insecure_private_key`
* SSH into the `core-01` compute node:
  * `vagrant ssh core-01 -- -A`
* check which compute nodes are present (along with their metadata tags):
  * `fleetctl list-machines`
* check that Fleet service scripts have been installed:
  * `fleetctl list-unit-files`
* check that all (expected) Docker Lift images have been downloaded:
  * `docker images`

Checking of Cassandra node:
* boot a Cassandra container:
  * `fleetctl start cassandra`
* check status of Cassandra:
  * `fleetctl status cassandra`
* check that Cassandra booted correctly:
  * `fleetctl journal cassandra`
  * `journalctl` (for general service starting failures)
* check Cassandra logging:
  * `fleetctl ssh cassandra`
  * `docker logs cassandra`

Checking of Akka cluster nodes:
* launch 3 'Hello World' micro-service:
  * `fleetctl start app@{1..3}`
* check that services have been launched:
  * `fleetctl list-units`
  * `fleetctl list-unit-files`
* view Akka cluster logging for a container:
  * `fleetctl ssh app@1`
  * `docker logs app-1`

Cluster formation:
* seed and form a cluster:
  * `fleetctl start seed`
* verify cluster formation:
  * `fleetctl ssh app@1`
  * `docker logs app-1`
