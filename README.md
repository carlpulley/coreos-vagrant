Basic setup:
* launch two Lift nodes:
  * `INSTANCE=1,2 CLOUD_CONFIG=lift/akka METADATA="lift=true" vagrant up`
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
* launch 1 notification, profile and exercise micro-service:
  * `fleetctl start notification@1 profile@1 exercise@1`
* check that services have been launched:
  * `fleetctl list-units`
  * `fleetctl list-unit-files`
* view Akka cluster logging for a container (e.g. exercise):
  * `fleetctl ssh exercise@1`
  * `docker logs exercise-1`

Cluster formation:
* seed and form a cluster:
  * `fleetctl start seed`
* verify cluster formation:
  * `fleetctl ssh exercise@1`
  * `docker logs exercise-1`
