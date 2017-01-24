#
# Cookbook Name:: sonarqube_wrapper
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.override['sonarqube']['web']['port'] = node['sonarqube']['web']['port']
include_recipe "sonarqube::default"
