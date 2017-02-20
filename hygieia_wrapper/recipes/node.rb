version = 'v5.4.1'
node.set['nvm']['nvm_install_test']['version'] = version

include_recipe 'nvm'
package 'npm'
nvm_install version do
  from_source false
#  user 'rashmisingh'
  user 'root'
  alias_as_default true
  action :create
end

# install bower and gulp globablly
execute 'install bower gulp' do
  command 'npm install -g bower gulp'
#  command 'sudo source /home/rashmisingh/.bashrc && npm install -g bower gulp'
  user 'root'
  group 'root'
  cwd '/root'
  not_if 'which bower'
end

template "/root/.bowerrc" do
  source 'bowerrc.erb'
end
