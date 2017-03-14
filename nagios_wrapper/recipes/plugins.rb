service 'nagios' do
 action :enable
end

#remote_file "/var/chef/cache/nagios-plugins-2.1.2.tar.gz" do
#  source "https://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz"
#end

#execute 'extract-nagios' do
#  cwd '/var/chef/cache/'
#  command 'tar -xvf nagios-plugins-2.1.2.tar.gz'
#  not_if { ::File.exist?("/var/chef/cache/nagios-plugins-2.1.2") }
#end


#bash 'compile-nagios' do
#  cwd '/var/chef/cache/'
#  code <<-EOH
#    cd nagios-plugins-2.1.2
#     ./configure
#    make
#    make install
#    setenforce 0
#  EOH
#  #action :nothing
#  #subscribes :run, 'execute[extract-nagios]', :immediately
#  notifies :restart, 'service[xinetd]', :immediately
#end

remote_file "/var/chef/cache/nagios-plugins-2.1.1.tar.gz" do
  source "http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz"
end

execute 'extract-nagios' do
  cwd '/var/chef/cache/'
  command 'tar xvf nagios-plugins-2.1.1.tar.gz'
  not_if { ::File.exist?("/var/chef/cache/nagios-plugins-2.1.1") }
end


bash 'compile-nagios' do
  cwd '/var/chef/cache/'
  code <<-EOH
    cd /var/chef/cache/nagios-plugins-2.1.1
    ./configure --with-nagios-user=nagios --with-nagios-group=nagios
    make 
    make install
  EOH
end
