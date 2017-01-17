

directory node['jenkins']['master']['home'] do
  action :create
  recursive true
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode '0755'
end
