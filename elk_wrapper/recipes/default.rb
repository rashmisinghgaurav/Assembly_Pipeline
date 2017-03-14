#
# Cookbook Name:: elk_wrapper
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'elk_wrapper::initial_setup'
include_recipe 'elk_wrapper::elasticsearch'
include_recipe 'elk_wrapper::kibana'
include_recipe 'elk_wrapper::kibana_nginx'
include_recipe 'elk_wrapper::logstash'
