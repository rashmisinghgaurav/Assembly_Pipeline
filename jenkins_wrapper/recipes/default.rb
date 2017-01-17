#
# Cookbook:: jenkins_wrapper
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.override['jenkins']['master']['install_method'] = node['jenkins']['master']['install_method']
#node.override['jenkins']['master']['version'] = node['jenkins']['master']['version']

include_recipe 'jenkins::master'

#Global configuration
 Chef::Log.info("Java home: #{node['jenkins']['java']}:")

#Port Change
 node.default['jenkins']['master']['port'] = 8085
 node.default['jenkins']['master']['endpoint'] = "http://#{node['jenkins']['master']['host']}:#{node['jenkins']['master']['port']}"


