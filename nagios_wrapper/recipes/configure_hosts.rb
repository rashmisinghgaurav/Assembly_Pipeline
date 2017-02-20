template "/usr/local/nagios/etc/hosts.cfg" do
 source 'hosts.cfg.erb'
 owner node['nagios']['user']
 group node['nagios']['group']
end

template "/usr/local/nagios/etc/services.cfg" do
source 'services.cfg.erb'
 owner node['nagios']['user']
 group node['nagios']['group']
end

node['nrpe']['client']['ip_list'].each do |ip|
 ruby_block 'enable services' do
  block do
   fe = Chef::Util::FileEdit.new("/usr/local/nagios/etc/hosts.cfg")    
   fe.insert_line_if_no_match("define host{\nuse linux-box\nhost_name #{ip}\naddress #{ip}\n}", "define host{\nuse linux-box\nhost_name #{ip}\naddress #{ip}\n}")
   fe.write_file
  end
 end
end


ruby_block "enable client services" do
  block do
    fe = Chef::Util::FileEdit.new("/usr/local/nagios/etc/nagios.cfg")
    fe.insert_line_if_no_match("cfg_file=/usr/local/nagios/etc/hosts.cfg", "cfg_file=/usr/local/nagios/etc/hosts.cfg")
    fe.write_file
  end
end


ruby_block "enable client services" do
  block do
    fe = Chef::Util::FileEdit.new("/usr/local/nagios/etc/nagios.cfg")
    fe.insert_line_if_no_match("cfg_file=/usr/local/nagios/etc/services.cfg", "cfg_file=/usr/local/nagios/etc/services.cfg")
    fe.write_file
  end
end




 ruby_block "enable nrpe_check command" do
  block do
    fe = Chef::Util::FileEdit.new("/usr/local/nagios/etc/objects/commands.cfg")
    fe.insert_line_if_no_match("/define command{\ncommand_name check_nrpe\ncommand_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$\n}/",  "define command{\ncommand_name check_nrpe\ncommand_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$\n}")
    fe.write_file
  end
  notifies :restart, 'service[nagios]', :immediately
end
