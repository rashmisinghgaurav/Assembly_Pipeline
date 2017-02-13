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
  not_if "docker images sonatype/nexus | grep sonatype/nexus"
end

docker_volume 'nexus' do
  action :create
  not_if "docker volume ls | grep nexus"
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


ruby_block 'wait for nexus' do
 block do
  loop do
   puts "Nexus is getting ready"
   sleep 10
   ` curl "http://localhost:8081/nexus/" `
   exitstatus = $?.exitstatus
   if exitstatus == 0
     break
   end
  end
 end
end

bash "create_release_repo" do
  code <<-EOH
  docker exec nexus curl -i -v -H "Content-Type:application/json" -H "Accept: application/json" -d "@/tmp/create_release_repository.json" -X POST -u admin:admin123 http://localhost:8081/nexus/service/local/repositories
  EOH
  not_if "  docker exec nexus curl -i -v -H 'Content-Type:application/json' -H 'Accept: application/json' -X GET -u admin:admin123 http://localhost:8081/nexus/service/local/repositories/release-repo"
end

bash "create_snapshot_repo" do
  code <<-EOH
  docker exec nexus curl -i -v -H "Content-Type:application/json" -H "Accept: application/json" -d "@/tmp/create_snapshot_repository.json" -X POST -u admin:admin123 http://localhost:8081/nexus/service/local/repositories
EOH
  not_if "  docker exec nexus curl -i -v -H 'Content-Type:application/json' -H 'Accept: application/json' -X GET -u admin:admin123 http://localhost:8081/nexus/service/local/repositories/snapshot-repo"
end

