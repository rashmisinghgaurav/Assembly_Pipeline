

node['jenkins']['master']['plugins_list'].each do |i|
  jenkins_plugin i do
   action :install
  end
end
