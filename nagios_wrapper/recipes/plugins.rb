remote_file "/var/chef/cache/nagios-plugins-2.1.4.tar.gz" do
  source "https://nagios-plugins.org/download/nagios-plugins-2.1.4.tar.gz"
end

execute 'extract-nagios' do
  cwd Chef::Config[:file_cache_path]
  command 'tar zxvf nagios-plugins-2.1.4.tar.gz'
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/nagios-plugins-2.1.4}") }
end

service 'nagios' do
action :enable
end

bash 'compile-nagios' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    cd nagios-plugins-2.1.4
    ./configure --prefix=/usr/local/nagios \
        --with-nagios-group=#{node['nagios']['group']} \
        --with-command-user=#{node['nagios']['user']} \
        --with-command-group=#{node['nagios']['group']} \
    make all 
    make install
    chkconfig --add nagios
    chkconfig nagios on
    setenforce 0
  EOH
  #action :nothing
  #subscribes :run, 'execute[extract-nagios]', :immediately
  notifies :restart, 'service[nagios]', :immediately
end

