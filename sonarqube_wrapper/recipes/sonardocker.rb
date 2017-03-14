#cookbook_file '/tmp/Dockerfile' do
#  source 'Dockerfile.erb'
#end

#cookbook_file '/tmp/run.sh' do
#  source 'run.sh.erb'
#end

docker_service 'default' do
  action [:create, :start]
end

docker_image 'sonarqube' do
  action :pull 
  not_if "docker images sonarqube | grep sonarqube"
end



#docker_volume 'sonarqube' do
#  action :create
#not_if "docker volume ls | grep sonarqube"
#end

docker_container 'sonarqube' do
  repo 'sonarqube'
  tag 'latest'
  port '8084:9000'
#  volume 'sonarqube:/sonarqube'
#  command 'rm -rf /opt/sonarqube/temp'
#  kill_after 300
  action :run
end


#Chef::Log.info("Delaying chef execution")
#execute 'delay' do
#  command 'sleep 120'
#end

ruby_block 'wait for sonarqube' do
 block do
  timeout(300) do
  loop do
   puts "\n Sonarqube is getting ready"
   sleep 30
   ` curl "http://localhost:8084" `
   exitstatus = $?.exitstatus
   if exitstatus == 0
     break
   end
   end
  end
 end
end

