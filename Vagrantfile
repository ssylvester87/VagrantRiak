# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

require './vagrant-provision-reboot-plugin'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.hostname = 'riak-2-0-ext'
  config.vm.network(:private_network, :ip => '192.168.56.40')

  config.vm.provider :virtualbox do |v|
    v.gui = false
    v.name = 'Riak 2.0 External'
    v.memory = 1024
  end

  riak_major_version = 2
  riak_minor_version = 0
  riak_patch_version = 2
  riak_simple_version = riak_major_version.to_s + "." + riak_minor_version.to_s
  riak_full_version = riak_major_version.to_s + "." + riak_minor_version.to_s + "." + riak_patch_version.to_s

  erlang_version = "otp_src_R16B02-basho5"

  numnodes = 5

  client_major_version = 2
  client_minor_version = 0
  client_patch_version = 1
  client_full_version = client_major_version.to_s + "." + client_minor_version.to_s + "." + client_patch_version.to_s

  config.vm.provision(:shell, path: 'env_deps.sh', args: "#{riak_full_version}")
  config.vm.provision(:unix_reboot)
  config.vm.provision(:shell, path: 'build_erl.sh', args: "#{erlang_version}", privileged: false)
  config.vm.provision(:shell, path: 'inst_erl.sh', args: "#{erlang_version}")
  config.vm.provision(:shell, path: 'riak.sh', args: "#{riak_simple_version} #{riak_full_version} #{numnodes.to_s} #{client_full_version}", privileged: false)
end
