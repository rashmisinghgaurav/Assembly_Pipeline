#
# Cookbook Name:: hygieia_wrapper
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


node.override['hygieia_liatrio']['jenkins_url'] = 'http://aniketm3.mylabserver.com:8080/'
#node.override['nvm']['rashmisingh'] = 'root'
#node.override['nvm']['group'] = 'root'
node.override['nvm']['repository'] = 'https://github.com/creationix/nvm.git'
#node.override['hygieia_liatrio']['home'] = '/home/hygieia/Hygieia'
node.override['hygieia_liatrio']['symlink'] = '/home/hygieia/Hygieia/UI/dist'
user  "#{node['hygieia_liatrio']['user']}" do 
  username node['hygieia_liatrio']['user'] 
#  group node['hygieia_liatrio']['group']
  home node['hygieia_liatrio']['home']
  shell '/bin/bash'
  manage_home true
 action :create
end

include_recipe 'hygieia-liatrio::mongodb'
include_recipe 'hygieia_wrapper::node'
#include_recipe 'hygieia_wrapper::hygieia'
#include_recipe 'hygieia-liatrio::apache2'
include_recipe 'hygieia_wrapper::new'
