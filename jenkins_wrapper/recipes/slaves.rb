node['jenkins']['configure_slaves']['slave_ip'].each do |slave_ip|
 jenkins_ssh_slave slave_ip do
  description "Run test suites"
  remote_fs node['jenkins']['configure_slaves']['remote_fs']
  labels [ "build_executors" ]

  ##SSH specific attributes
  host   slave_ip
  user   "user"
  credentials 'aniketm4-password'
  usage_mode "normal"
  availability "always"
 end
end
