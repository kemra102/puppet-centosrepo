nodes = [
  #{ :hostname => 'centos7pe',   :ip => '192.168.72.2',  :box => 'puppetlabs/centos-7.2-64-puppet-enterprise' },
  { :hostname => 'centos7',     :ip => '192.168.72.3',  :box => 'puppetlabs/centos-7.2-64-puppet' },
  #{ :hostname => 'centos6',     :ip => '192.168.72.4',  :box => 'puppetlabs/centos-6.6-64-puppet' },
  #{ :hostname => 'centos5',    :ip => '192.168.72.5',  :box => 'puppetlabs/centos-5.11-64-puppet' }
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname] + '.box'
      nodeconfig.vm.network :private_network, ip: node[:ip]

      memory = node[:ram] ? node[:ram] : 256;
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--cpuexecutioncap', "50",
          '--memory', memory.to_s,
        ]
      end
    end
  end

  config.vm.provision :shell do |shell|
    script = "mkdir -p /etc/puppetlabs/code/environments/production/modules/centosrepo;" +
    "cp -r /vagrant/* /etc/puppetlabs/code/environments/production/modules/centosrepo/;" +
    'export PATH=$PATH:/opt/puppetlabs/puppet/bin;' +
    'export MODULEPATH=/etc/puppetlabs/code/environments/production/modules/;' +
    "puppet apply --pluginsync --modulepath=$MODULEPATH \"$MODULEPATH\"centosrepo/tests/init.pp;"
    shell.inline = script
  end
end
