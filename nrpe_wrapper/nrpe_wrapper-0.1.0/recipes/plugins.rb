remote_file "/var/chef/cache/nagios-plugins-2.1.2.tar.gz" do
  source "https://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz"
end

execute 'extract-nagios' do
  cwd Chef::Config[:file_cache_path]
  command 'tar zxvf nagios-plugins-2.1.2.tar.gz'
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/nagios-plugins-2.1.2}") }
end


bash 'compile-nagios' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    cd nagios-plugins-2.1.2
#    ./configure --prefix=/usr/local/nagios \
     ./configure
#        --with-command-group=#{node['nrpe']['group']} \
    make
    make install
    setenforce 0
  EOH
  #action :nothing
  #subscribes :run, 'execute[extract-nagios]', :immediately
#  notifies :restart, 'service[xinetd]', :immediately
end

