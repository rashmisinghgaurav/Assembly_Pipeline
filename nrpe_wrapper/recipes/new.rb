node.override['nrpe']['allowed_hosts'] = %w(127.0.0.1 54.201.229.89)
node.override['nrpe']['server_port'] = '8082'
node.override['nrpe']['home']  = '/usr/local/nagios'
node.override['nrpe']['plugin_dir'] = '/usr/local/nagios/libexec'
include_recipe 'nrpe::default'

