# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'erb'
require 'fileutils'

Vagrant.require_version ">= 1.6.0"

if ENV['CLOUD_CONFIG'].nil?
  puts "WARNING: CLOUD_CONFIG environment variable is unspecified - using the ERB template cloud-config/default.erb"
end

if ENV['METADATA'].nil?
  puts "WARNING: no METADATA environment variable has been specified - setting it to be an empty string"
end

@metadata = ENV['METADATA'] || ""

user_data = ENV['CLOUD_CONFIG'] || "default"

CLOUD_CONFIG_PATH = "/tmp/vagrantfile-user-data"
CONFIG = File.join(File.dirname(__FILE__), "config.rb")

# Defaults for config options defined in CONFIG
$update_channel = "alpha"
$enable_serial_logging = false
$vb_gui = false
$vb_memory = 1024
$vb_cpus = 1

if File.exist?(CONFIG)
  require CONFIG
end

# CoreOS cluster numbers that Vagrant should create - these should be a comma separated string of positive numbers (values should be in the range 1-253)
@instances = (ENV['INSTANCE'] || `VBoxManage list vms`.split("\n").select { |m| /_core-(\d\d)_\d+_\d+/ =~ m }.map { |m| /_core-(\d\d)_\d+_\d+/.match(m)[1].to_i }.join(",")).split(",").map { |i| Integer(i.strip) }

if @instances.empty?
  puts "ERROR: config.rb has an empty @instances array and no INSTANCE environment variable has been specified - these should be a comma separated string of positive numbers (values should be in the range 1-253)"
  exit
end

# Generate a new UUID token if this is the first time that we have used 'up' with this Vagrant box
if ARGV[0].eql?('up') && (!File.exist?('.token') || `VBoxManage list vms`.split("\n").select { |m| /_core-(\d\d)_\d+_\d+/ =~ m }.empty?)
  require 'open-uri'
 
  @token = open('https://discovery.etcd.io/new').read.strip
  while /\/([a-f0-9]{32})$/ !~ @token do
    @token = open('https://discovery.etcd.io/new').read.strip
  end
  @token = /\/([a-f0-9]{32})$/.match(@token)[1]
  puts "Generated new discovery token: #{@token}"
  # and ensure that the token is saved for any future invocations
  File.open('.token', 'w') { |file| file.write(@token) }
elsif File.exist?('.token')
  # Read a previously saved token
  @token = File.read('.token').strip
  puts "Using existing discovery token: #{@token}"
end

template = File.join(File.dirname(__FILE__), "cloud-config/#{user_data}.erb")
File.open(CLOUD_CONFIG_PATH, 'w') { |fd| fd.write(ERB.new(File.read(template), 0, "<>", "_config").result(binding)) }

Vagrant.configure("2") do |config|
  config.vm.box = "coreos-%s" % $update_channel
  config.vm.box_version = ">= 308.0.1"
  config.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % $update_channel

  config.vm.provider :vmware_fusion do |vb, override|
    override.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant_vmware_fusion.json" % $update_channel
  end

  config.vm.provider :virtualbox do |v|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    v.check_guest_additions = false
    v.functional_vboxsf     = false
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  @instances.each do |i|
    config.vm.define vm_name = "core-%02d" % i do |config|
      config.vm.hostname = vm_name

      if $enable_serial_logging
        logdir = File.join(File.dirname(__FILE__), "log")
        FileUtils.mkdir_p(logdir)

        serialFile = File.join(logdir, "%s-serial.txt" % vm_name)
        FileUtils.touch(serialFile)

        config.vm.provider :vmware_fusion do |v, override|
          v.vmx["serial0.present"] = "TRUE"
          v.vmx["serial0.fileType"] = "file"
          v.vmx["serial0.fileName"] = serialFile
          v.vmx["serial0.tryNoRxLoss"] = "FALSE"
        end

        config.vm.provider :virtualbox do |vb, override|
          vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
          vb.customize ["modifyvm", :id, "--uartmode1", serialFile]
        end
      end

      if $expose_docker_tcp
        config.vm.network "forwarded_port", guest: 2375, host: ($expose_docker_tcp + i - 1), auto_correct: true
      end

      config.vm.provider :vmware_fusion do |vb|
        vb.gui = $vb_gui
      end

      config.vm.provider :virtualbox do |vb|
        vb.gui = $vb_gui
        vb.memory = $vb_memory
        vb.cpus = $vb_cpus
      end

      ip = "172.17.8.#{i+100}"
      config.vm.network :private_network, ip: ip

      # Uncomment below to enable NFS for sharing the host machine into the coreos-vagrant VM.
      #config.vm.synced_folder ".", "/home/core/share", id: "core", :nfs => true, :mount_options => ['nolock,vers=3,udp']

      if File.exist?(CLOUD_CONFIG_PATH)
        config.vm.provision :file, :source => CLOUD_CONFIG_PATH, :destination => "/tmp/vagrantfile-user-data"
        config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
      end

    end
  end
end
