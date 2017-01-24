file "#{node['jenkins']['master']['home']}/plugins_installed" do
 owner node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
 mode '0644'
 action :create
 not_if { ::File.exists?("{node['jenkins']['master']['home']}/plugins_installed") }
end

node['jenkins']['master']['plugins_list'].each do |i|
  jenkins_plugin i do
   action :install
   not_if "grep #{i} #{node['jenkins']['master']['home']}/plugins_installed"   
  end
end

file "#{node['jenkins']['master']['home']}/plugins_installed" do
  content node['jenkins']['master']['plugins_list'].map(&:inspect).join(",")
  action :create
end
