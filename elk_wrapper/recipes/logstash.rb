package 'unzip'
template '/etc/yum.repos.d/logstash.repo' do
 source 'logstash.repo.erb'
end

package 'logstash'
package 'openssl'

template "/etc/pki/tls/openssl.cnf" do
 source 'openssl.conf.erb'
end

template "/etc/pki/tls/certs/logstash-forwarder.crt" do
 source 'logstash-forwarder.crt.erb'
end

template "/etc/pki/tls/private/logstash-forwarder.key" do
 source 'logstash-forwarder.key.erb'
end

template "/etc/logstash/conf.d/02-beats-input.conf" do
  source '02-beats-input.conf.erb'
end

template "/etc/logstash/conf.d/10-syslog-filter.conf" do
 source '10-syslog-filter.conf.erb'
end

template "/etc/logstash/conf.d/30-elasticsearch-output.conf" do
 source '30-elasticsearch-output.conf.erb'
end

service 'logstash' do
 action [:enable, :restart]
end


bash 'load_kibana_dashboard' do
 code <<-EOH
 cd /tmp
 curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip
 unzip /tmp/beats-dashboards-1.1.0.zip -d /tmp
 cd /tmp/beats-dashboards-1.1.0
 /tmp/beats-dashboards-1.1.0/load.sh
 EOH
end

bash 'load_filebeat_index' do
 code <<-EOH
 cd /tmp
 curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json
 curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@/tmp/filebeat-index-template.json
 EOH
end
