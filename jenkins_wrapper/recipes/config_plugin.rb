### Configure Sonar-scanner on jenkins global tool configuration
template "#{node['jenkins']['master']['home']}/hudson.plugins.sonar.SonarRunnerInstallation.xml" do
 source 'hudson.plugins.sonar.SonarRunnerInstallation.xml.erb'
 owner node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
 action :create
 mode '0644'
end


### Configure Sonarqube server in Jenkins system configuration
template "#{node['jenkins']['master']['home']}/hudson.plugins.sonar.SonarGlobalConfiguration.xml" do
 source 'hudson.plugins.sonar.SonarGlobalConfiguration.xml.erb'
 owner node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
 action :create
 mode '0644'
end

### Configure GIT on jenkins global tool configuration
package 'git'
package 'maven'

remote_file "#{node['jenkins']['master']['home']}/plugins/git.hpi" do
 source "http://updates.jenkins-ci.org/latest/git.hpi"
end

template "#{node['jenkins']['master']['home']}/hudson.plugins.git.GitTool.xml" do
 source 'hudson.plugins.git.GitTool.xml.erb'
 owner node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
 action :create
 mode '0644'
end

template "#{node['jenkins']['master']['home']}/github-plugin-configuration.xml" do
 source 'github-plugin-configuration.xml.erb'
 owner node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
 action :create
 mode '0644'
end


template "#{node['jenkins']['master']['home']}/hudson.plugins.git.GitSCM.xml" do
 source 'hudson.plugins.git.GitSCM.xml.erb'
 owner node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
 action :create
 mode '0644'
end

