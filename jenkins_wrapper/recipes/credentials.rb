aniketm4 = Chef::EncryptedDataBagItem.load('keys', 'private_key')['aniketm4']

jenkins_password_credentials 'user' do
  id          'aniketm4-password'
  password    aniketm4
end

jenkins_password_credentials 'OrclDemo' do
  id          'al-password'
  description 'Username and password for AssemblyLine GitHub Repo'
  password    'ATBG91dY'
end

