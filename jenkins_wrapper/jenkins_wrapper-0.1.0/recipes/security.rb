#ruby_block "replace_line" do
#  block do
#    file = Chef::Util::FileEdit.new("#{node['jenkins']['master']['home']}/config.xml")
#    file.search_file_replace_line("/<useSecurity>true</useSecurity>/", "<useSecurity>false</useSecurity>")
#    file.write_file
#  end
#  notifies :restart, 'service[jenkins]', :immediately
#end

template "#{node['jenkins']['master']['home']}/config.xml" do
 source "config.xml.erb"
 user node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
# notifies :stop, 'service[jenkins]', :immediately
 notifies :restart, 'service[jenkins]', :immediately
end


Chef::Log.info("Delaying chef execution")
execute 'delay' do
  command 'sleep 60'
end


jenkins_plugin 'matrix-auth' 
jenkins_plugin 'credentials'
jenkins_plugin 'ssh-slaves' 
#jenkins_plugin 'credentials' do
#notifies :restart, 'runit_service[jenkins]', :immediately
#end

#jenkins_command 'safe-restart'

#Chef::Log.info("Delaying chef execution")
#execute 'delay' do
#  command 'sleep 90'
#end

bash 'stop_jenkins' do
  code <<-EOH
  #/sbin/sv -w '120' stop /etc/service/jenkins    
  #kill -9 $(ps aux | grep 'jenkins.war --httpPort=8080' | awk '{print $2}')
  service jenkins stop
EOH
end
