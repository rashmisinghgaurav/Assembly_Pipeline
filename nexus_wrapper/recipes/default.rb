#
# Cookbook Name:: nexus_wrapper
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

docker_service 'default' do
  action [:create, :start]
end

docker_image 'sonatype/nexus' do
  action :pull
end

docker_volume 'nexus' do
  action :create
end

docker_container 'nexus' do
  repo 'sonatype/nexus'
  port '8081:8081'
  volumes 'nexus:/nexus'
  action :run
end

cookbook_file '/tmp/create_release_repository.json' do
 source 'create_release_repository.json.erb'
end

cookbook_file '/tmp/create_snapshot_repository.json' do
 source 'create_snapshot_repository.json.erb'
end

bash "copy json to container" do
  code <<-EOH
    docker cp /tmp/create_release_repository.json nexus:/tmp
    docker cp /tmp/create_snapshot_repository.json nexus:/tmp
  EOH
end



bash "create_release_repo" do
  code <<-EOH
  docker exec nexus curl -i -v -H "Content-Type:application/json" -H "Accept: application/json" -d "@/tmp/create_release_repository.json" -X POST -u admin:admin123 http://localhost:8081/nexus/service/local/repositories
  EOH
end

bash "create_release_repo" do
  code <<-EOH
  docker exec nexus curl -i -v -H "Content-Type:application/json" -H "Accept: application/json" -d "@/tmp/create_snapshot_repository.json" -X POST -u admin:admin123 http://localhost:8081/nexus/service/local/repositories
  EOH
end

