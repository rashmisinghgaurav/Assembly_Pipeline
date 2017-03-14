#
# Cookbook Name:: nrpe_wrapper
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'nrpe_wrapper::yum'
ruby_block "enable kernel updates" do
  block do
    file = Chef::Util::FileEdit.new("/etc/yum.conf")
    file.search_file_replace( "exclude=kernel* redhat-release*", "exclude=redhat-release*")
    file.write_file
  end
end

#node.override['nrpe']['server_address'] = 'aniketm1.mylabserver.com'
#node.override['nrpe']['allowed_hosts'] = %w( aniketm1.mylabserver.com )
node.override['nrpe']['service_name'] = 'xinetd'
include_recipe 'nrpe_wrapper::source'
include_recipe 'nrpe_wrapper::plugins'
