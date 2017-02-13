#
# Cookbook Name:: sonarqube_wrapper
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.override['sonarqube']['web']['port'] = node['sonarqube']['web']['port']
node.override['sonarqube']['scanner']['host']['url'] = node['sonarqube']['scanner']['host']['url']  
include_recipe "sonarqube::default"


template "/var/lib/jenkins/hudson.plugins.sonar.SonarGlobalConfiguration.xml" do
source "hudson.plugins.sonar.SonarGlobalConfiguration.xml.erb"
#notifies :restart, 'service[sonarqube]', :immediately
end

