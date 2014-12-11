
#
# coreos-vagrant-weave is configured through a series of configuration
# options (global ruby variables) which are detailed below. To modify
# these options, first copy this file to "config.rb". Then simply
# uncomment the necessary lines, leaving the $, and replace everything
# after the equals sign..

# Official CoreOS channel from which updates should be downloaded
$update_channel='beta'

# Log the serial consoles of CoreOS VMs to log/
# Enable by setting value to true, disable with false
# WARNING: Serial logging is known to result in extremely high CPU usage with
# VirtualBox, so should only be used in debugging situations
#$enable_serial_logging=false

# Enable port forwarding of Docker TCP socket
# Set to the TCP port you want exposed on the *host* machine, default is 2375
# If 2375 is used, Vagrant will auto-increment (e.g. in the case of $num_instances > 1)
# You can then use the docker tool locally by setting the following env var:
#   export DOCKER_HOST='tcp://127.0.0.1:2375'
#$expose_docker_tcp=2375

# Setting for VirtualBox VMs
#$vb_gui = false
$vb_memory = 2048 # 2GB
#$vb_cpus = 1

# Docker images that our distributed application will use
@docker = {
  :vulcand       => "mailgun/vulcand",
  :cassandra     => "spotify/cassandra",
  :app           => "carlpulley/helloworld:v0.1.0-SNAPSHOT"
#  :exercise     => "carlpulley/lift:lift-exercise",
#  :notification => "carlpulley/lift:lift-notification",
#  :profile      => "carlpulley/lift:lift-profile"
}

# List of service templates that we want on each compute node
@service_templates = [
  "vulcand.service",
  "cassandra@.service",
  "seed@.service",
  "helloworld/app@.service"
#  "lift/exercise@.service",
#  "lift/notification@.service",
#  "lift/profile@.service"
]

# Authentication information for accessing the Docker repository
@username='USERNAME'
@password='PASSWORD'
@email='EMAIL'
