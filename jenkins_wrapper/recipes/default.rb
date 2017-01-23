#
# Cookbook:: jenkins_wrapper
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.override['jenkins']['master']['install_method'] = node['jenkins']['master']['install_method']
#node.override['jenkins']['master']['version'] = node['jenkins']['master']['version']
#node.override['jenkins']['master']['host'] = '10.184.247.9'
#node.override['jenkins']['master']['version'] = '1.642-1.1'
#node.override['jenkins']['master']['jvm_options'] = '-Djenkins.install.runSetupWizard=false'
#node.override['jenkins']['executor']['timeout'] = '480'
node.override['master']['runit']['sv_timeout'] = '60'

include_recipe 'jenkins::master'

#Global configuration
 Chef::Log.info("Java home: #{node['jenkins']['java']}:")

#Port Change
# node.default['jenkins']['master']['port'] = 8085
 node.default['jenkins']['master']['endpoint'] = "http://#{node['jenkins']['master']['host']}:#{node['jenkins']['master']['port']}"

