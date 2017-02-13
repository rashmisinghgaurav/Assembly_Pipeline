user node['nagios']['user'] do
  action :create
end

#ruby_block "enable kernel updates" do
#  block do
#    fe = Chef::Util::FileEdit.new("/etc/yum.conf")
#    fe.search_file_replace(/exclude=kernel* redhat-release*/,"exclude=redhat-release*")
#    fe.write_file
#  end
#end

package 'httpd'
package 'php'
package 'gcc'
package 'glibc'
package 'glibc-common'
package 'gd'
package 'gd-devel'
#ackage 'build-essentials'
package 'php'
package 'unzip'

#include_recipe 'build-essential'

service 'httpd' do
 action [:enable, :start]
end

remote_file "/var/chef/cache/nagios-4.1.1.tar.gz" do
  source "https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz"
end

execute 'extract-nagios' do
  cwd Chef::Config[:file_cache_path]
  command 'tar zxvf nagios-4.1.1.tar.gz'
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/nagios-4.1.1}") }
end


bash 'compile-nagios' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    cd nagios-4.1.1
    ./configure --with-command-group=#{node['nagios']['group']} 
    make all
    make install
    make install-init
    make install-config
    make install-commandmode
    make install-webconf
    htpasswd -c -b /usr/local/nagios/etc/htpasswd.users nagiosadmin password    
  EOH
  #action :nothing
  #subscribes :run, 'execute[extract-nagios]', :immediately
  notifies :restart, 'service[httpd]', :immediately
end


