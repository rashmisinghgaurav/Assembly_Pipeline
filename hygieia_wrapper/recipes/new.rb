# add java
include_recipe 'java' do
  not_if 'which java'
end

# install git
package 'git' do
  not_if 'which git'
end

# install bzip2
package 'bzip2' do
  not_if 'which bzip2'
end

# install maven 3.3.9
yum_package 'apache-maven' do
  version '3.3.9-3.el7'
  not_if 'mvn -version | grep "Apache Maven 3.1.9"'
end

# create hygieia group
group 'create hygieia group' do
  group_name node['hygieia_liatrio']['group']
  action :create
end

# ensure hygieia user home directory is 755
directory node['hygieia']['home'] do
  mode 0777
end

# clone Hygieia
git "#{node['hygieia']['home']}" do
  repository 'https://github.com/liatrio/Hygieia.git'
  revision 'master'
  action :sync
  user node['hygieia_liatrio']['user']
#  not_if 'ls -d /home/hygieia/Hygieia/UI'
end

# Add Hygieia dashboard.properties for collector config
template "#{node['hygieia']['home']}/dashboard.properties" do
  source 'dashboard.properties.erb'
  user node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  mode '0644'
end


# ensure hygieia user home directory is 755
directory node['hygieia']['home'] do
  mode 0755
  user node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  recursive true
end

#template "/root/.bowerrc" do
#  source 'bowerrc.erb'
#end

bash 'compile hygieia' do
 cwd #{node['hygieia']['home']}
 code <<-EOH
 cd #{node['hygieia']['home']}
 mvn clean install package
EOH
not_if { ::File.exist?("#{node['hygieia']['home']}/api/target/api.jar") }
end

bash 'compile hygieia_api' do
 cwd #{node['hygieia']['home']}/api
 code <<-EOH
 cd #{node['hygieia']['home']}/api
  mvn install
 java -jar #{node['hygieia']['home']}/api/target/api.jar --spring.config.location=#{node['hygieia']['home']}/dashboard.properties &
EOH
not_if 'netstat -an | grep 8080'
end

directory node['hygieia']['home'] do
  mode 0755
  user node['hygieia_liatrio']['user']
  group node['hygieia_liatrio']['group']
  recursive true
end

#template "#{node['hygieia']['home']}/core/pom.xml" do
# source "pom.xml.erb"
#  user node['hygieia_liatrio']['user']
#  group node['hygieia_liatrio']['group']
#  mode 0755
#end




bash 'compile hygieia_core' do
 code <<-EOH
 cd #{node['hygieia']['home']}/core
 mvn clean install
EOH
#not_if { ::File.exist?("#{node['hygieia']['home']}/core/target/core-2.0.5-SNAPSHOT.jar") }
end

bash 'compile hygieia_jenkins' do
 code <<-EOH
 cd #{node['hygieia']['home']}/hygieia-jenkins-plugin
 mvn test
 mvn clean install
EOH
end

bash 'compile hygieia_github' do
 code <<-EOH
 cd #{node['hygieia']['home']}/collectors/scm/github/
 mvn  install
EOH
not_if { ::File.exist?("#{node['hygieia']['home']}/collectors/scm/github/target/github-scm-collector*.jar") }
end

bash 'run_github' do
 code <<-EOH
 java -jar #{node['hygieia']['home']}/collectors/scm/github/target/github-scm-collector-2.0.5-SNAPSHOT.jar --spring.config.location=#{node['hygieia']['home']}/dashboard.properties &
EOH
end



template "/etc/systemd/system/hygieia-ui.service" do
    source 'hygieia-ui.service'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end

template "/etc/systemd/system/hygieia-github.service" do
    source 'hygieia-github.service'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end


# changes in /etc/systemd/system need this
execute 'systemctl daemon-reload' do
  command 'systemctl daemon-reload'
  user 'root'
end

# enable each collector and boot and start immediately
service "hygieia-ui" do
    action [:enable, :start]
  end

service "hygieia-github" do
    action [:enable, :start]
  end

