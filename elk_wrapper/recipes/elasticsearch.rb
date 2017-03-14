#rpm_package 'GPG-KEY-elasticsearch' do
# source 'http://packages.elastic.co/GPG-KEY-elasticsearch'
# action :install
#end

execute 'import_elasticsearch_key' do
 command 'rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch'
 user 'root'
end


template '/etc/yum.repos.d/elasticsearch.repo' do
 source 'elasticsearch.repo.erb'
end

package 'elasticsearch'

service 'elasticsearch' do
 action [:enable, :start]
end
