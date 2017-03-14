include_recipe 'java_wrapper'

user "#{node['elk']['user']}" do
 action :create
 group 'wheel'
end
