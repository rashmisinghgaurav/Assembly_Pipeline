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
 notifies :restart, 'service[jenkins]', :immediately
end

Chef::Log.info("Delaying chef execution")
execute 'delay' do
  command 'sleep 60'
end

jenkins_plugin 'matrix-auth' 
jenkins_plugin 'ssh-slaves' 
jenkins_plugin 'credentials' do
notifies :restart, 'service[jenkins]', :immediately
end

