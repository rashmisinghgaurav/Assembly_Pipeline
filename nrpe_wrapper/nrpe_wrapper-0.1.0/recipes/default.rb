#
# Cookbook Name:: nrpe_wrapper
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#node.override['nrpe']['server_address'] = 'aniketm1.mylabserver.com'
#node.override['nrpe']['allowed_hosts'] = %w( aniketm1.mylabserver.com )
node.override['nrpe']['service_name'] = 'xinetd'
#include_recipe 'nrpe::default'
include_recipe 'nrpe_wrapper::plugins'
include_recipe 'nrpe_wrapper::source'
include_recipe 'nrpe::configure'
