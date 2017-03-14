package 'epel-release'
package 'nginx'
package 'httpd-tools'

service 'nginx' do
 action :enable
end

execute 'set_nginx_password' do
 command 'htpasswd -c -b /etc/nginx/htpasswd.users kibanaadmin password'
 user 'root'
end

template '/etc/nginx/nginx.conf' do
 source 'nginx.conf.erb'
end
template '/etc/nginx/conf.d/kibana.conf' do
 source 'kibana.conf.erb'
 notifies :restart, 'service[nginx]', :immediately
end

