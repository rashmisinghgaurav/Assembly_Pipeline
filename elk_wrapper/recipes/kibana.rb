template "/etc/yum.repos.d/kibana.repo" do
 source 'kibana.repo.erb'
end

package 'kibana'

service 'kibana' do
 action [:enable, :start]
end

