file "#{node['jenkins']['master']['home']}/plugins_installed" do
 owner node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
 mode '0644'
 not_if { File.exists?("#{node['jenkins']['master']['home']}/plugins_installed") }
end


node['jenkins']['master']['plugins_list'].each do |i|
  jenkins_plugin i do
   action :install
  end
end

jenkins_plugin 'matrix-project' do
version '1.8'
end

jenkins_plugin 'token-macro' do
version '2.0'
end

jenkins_plugin 'git' do
version '3.0.5'
end

file "#{node['jenkins']['master']['home']}/plugins_installed" do
  content node['jenkins']['master']['plugins_list'].map(&:inspect).join(",")
  action :create
end
