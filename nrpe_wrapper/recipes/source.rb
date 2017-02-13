include_recipe 'build-essential'

pkgs = value_for_platform_family(
  %w(rhel fedora) => %w(openssl-devel tar which xinetd),
  'debian' => %w(libssl-dev tar),
  'gentoo' => [],
  'default' => %w(libssl-dev tar),
  'suse' => %w(libopenssl-devel tar which)
)

# install the necessary prereq packages for compiling NRPE
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

group node['nrpe']['group']

user node['nrpe']['user'] do
  system true
  group node['nrpe']['group']
end


remote_file "#{Chef::Config[:file_cache_path]}/nrpe-#{node['nrpe']['version']}.tar.gz" do
  source "#{node['nrpe']['url']}/nrpe-#{node['nrpe']['version']}.tar.gz"
  checksum node['nrpe']['checksum']
  action :create_if_missing
end

#if node['init_package'] == 'systemd'
#  execute 'nrpe-reload-systemd' do
#    command '/bin/systemctl daemon-reload'
#    action :nothing
#  end

  # if we use systemd, make the nrpe.service a template to correct the user
 # template "#{node['nrpe']['systemd_unit_dir']}/nrpe.service" do
 #   source 'nrpe.service.erb'
 #   notifies :run, 'execute[nrpe-reload-systemd]', :immediately
 #   notifies :restart, 'service[nrpe]', :delayed
 #   variables(
 #     nrpe: node['nrpe']
 #   )
 # end
#else
 # template '/etc/init.d/nrpe' do
 #   source 'nagios-nrpe-server.erb'
 #   mode '0754'
 # end
#end

directory node['nrpe']['conf_dir'] do
  group node['nrpe']['group']
  mode  '0750'
end

bash 'compile-nagios-nrpe' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxvf nrpe-#{node['nrpe']['version']}.tar.gz
    cd nrpe-#{node['nrpe']['version']}
    ./configure             --localstatedir=/var \
                --enable-command-args \
                --with-nagios-user=#{node['nrpe']['user']} \
                --with-nagios-group=#{node['nrpe']['group']} \
                --with-nrpe-user=#{node['nrpe']['user']} \
                --with-nrpe-group=#{node['nrpe']['group']} \
 		--with-ssl=/usr/bin/openssl \
                --with-ssl-lib=#{node['nrpe']['ssl_lib_dir']}

    make all
    make install
    make install-plugin
    make install-daemon
    make install-daemon-config
    make install-xinetd
  EOH
  not_if 'which nrpe'
end

include_recipe 'nrpe::_source_plugins'
