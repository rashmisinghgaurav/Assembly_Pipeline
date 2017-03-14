template "/etc/yum.repos.d/elastic-beats.repo" do
 source 'elastic-beats.repo.erb'
end

package 'filebeat'

service 'filebeat' do
 action :enable
end

template "/etc/filebeat/filebeat.yml" do
 source "filebeat.yml.erb"
end

template "/etc/pki/tls/certs/logstash-forwarder.crt" do
 source 'logstash-forwarder.crt.erb'
 notifies :restart, 'service[filebeat]', :immediately
end
