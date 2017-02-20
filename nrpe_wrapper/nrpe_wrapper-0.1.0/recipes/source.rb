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


remote_file "#{Chef::Config[:file_cache_path]}/nrpe-3.0.tar.gz" do
  source "http://liquidtelecom.dl.sourceforge.net/project/nagios/nrpe-3.x/nrpe-3.0.tar.gz"
end

directory node['nrpe']['conf_dir'] do
  group node['nrpe']['group']
  mode  '0750'
end

bash 'compile-nagios-nrpe' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxvf nrpe-3.0.tar.gz
    cd nrpe-3.0
    ./configure --prefix=/usr/local/nagios \          
    
    make all
    make install
    make install-plugin
    make install-daemon
    make install-daemon-config
    make install-inetd
  EOH
end

template '/etc/xinetd.d/nrpe' do
   source 'nrpe.cfg.erb'
   mode '0754'
 end

include_recipe 'nrpe::_source_plugins'

ruby_block 'enable_nrpe_port' do
  block do
    fe = Chef::Util::FileEdit.new("/etc/services")
    fe.insert_line_if_no_match("nrpe 5666/tcp NRPE", "nrpe #{node['nrpe']['server_port']}/tcp NRPE")
    fe.write_file
  end
end

