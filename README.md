Basic setup:
* first generate a new discovery token (and add it to `config.rb`):
  * `curl https://discovery.etcd.io/new`
* launch two Lift nodes:
  * `INSTANCE=1,2 CLOUD_CONFIG=lift-cluster METADATA="type=lift" vagrant up`
* launch a Cassandra node:
  * `INSTANCE=3 CLOUD_CONFIG=cassandra METADATA="type=cassandra" vagrant up`

Sanity checking compute nodes:
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

**FIXME:** currently, clusters are not forming because Akka applications are not booting - need to investigate further!
