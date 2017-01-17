#
# Cookbook Name:: java_wrapper
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.override['java']['jdk_version'] = node['java']['jdk_version']
node.override['java']['install_flavor'] = node['java']['install_flavor']
node.override['java']['oracle']['accept_oracle_download_terms'] = node['java']['oracle']['accept_oracle_download_terms']
node.override['java']['oracle_rpm']['type'] = node['java']['oracle_rpm']['type']   
include_recipe 'java::default'
