#
# Cookbook:: docker_wrapper
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
docker_service 'default' do
  action [:create, :start]
end
