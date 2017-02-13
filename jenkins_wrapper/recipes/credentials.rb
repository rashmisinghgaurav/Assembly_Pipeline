aniketm4 = Chef::EncryptedDataBagItem.load('keys', 'private_key')['aniketm4']
OrclDemo = Chef::EncryptedDataBagItem.load('keys', 'private_key')['OrclDemo']
aniketm5 = Chef::EncryptedDataBagItem.load('keys', 'private_key')['aniketm5']
nexus_admin = Chef::EncryptedDataBagItem.load('keys', 'private_key')['nexus-admin']

jenkins_password_credentials 'user' do
  id          'aniketm4-password'
  password    aniketm4
end

jenkins_password_credentials 'OrclDemo' do
  id          'al-password'
  description 'Username and password for AssemblyLine GitHub Repo'
  password    OrclDemo
end

jenkins_password_credentials 'user' do
  id          'aniketm5-password'
  password    aniketm5
end

jenkins_password_credentials 'admin' do
  id 'nexus-admin'
  password  nexus_admin
end

