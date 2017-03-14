#
# Cookbook:: tomcat_wrapper
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
#

#node.override['tomcat']['version']= node['tomcat']['version']


tomcat_install 'tomcat_ws' do
  version '7.0.75'
end

tomcat_service 'tomcat_ws' do
  action :start
end


template "tomcat-users config" do
  path ::File.join(node['tomcat']['conf'], 'tomcat-users.xml')
  source 'tomcat-users.xml.erb'
 end

node.override['tomcat']['port']= node['tomcat']['port']


tomcat_service 'tomcat_ws' do
  action :restart
end

