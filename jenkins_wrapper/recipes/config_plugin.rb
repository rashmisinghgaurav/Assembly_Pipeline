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


template "#{node['jenkins']['master']['home']}/hudson.plugins.git.GitTool.xml" do
 source 'hudson.plugins.git.GitTool.xml.erb'
 owner node['jenkins']['master']['user']
 group node['jenkins']['master']['group']
 action :create
 mode '0644'
end

