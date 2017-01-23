admin_key = Chef::EncryptedDataBagItem.load('keys', 'private_key')['key']
node.run_state[:jenkins_private_key] = admin_key

#ruby_block 'set jenkins private key' do
#  block do
#    node.run_state[:jenkins_private_key] = 'private_key'
#  end
#  only_if { node.attribute?('security_enabled') }
#end

jenkins_user 'admin' do
 password "admin"
 public_keys ['ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAn79M3W0/rvUTSHztSv3EqO11W9Y/1TxlsirpZ3JjcxHnvu3BVB81W4sJzoi14ZQ219nvJ3owatWcJHvTgzgpamHEIivIif7HN1zAmJIpIFSUn8/LcB1Eo93ox4g2P0p4HAs+BsiwvnrjmDuih7IK/e7/zRuaKxCxli49e21FDuDT3vk+4d6T8XLWbD97r7tWDRgB0ZkOr0FSIHETnKlzgQG4H7oiv2+805dZSuKh73hCicfLdPgU/cc8qB2t60IoR1ke3NeuOce+LuNvPHVHmZV0NBapJ70xnTqMXKud/bqtmEx0xgY9RIVzFF90FQBJeySn2MmYOB0mtZR/aNdHOQ== rsa-key-20170120']
  notifies :execute, 'jenkins_script[configure permissions]', :immediately
end

jenkins_script 'configure permissions' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*
    def instance = Jenkins.getInstance()
    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    instance.setSecurityRealm(hudsonRealm)
    def strategy = new GlobalMatrixAuthorizationStrategy()
    strategy.add(Jenkins.ADMINISTER, "admin")
    strategy.add(hudson.model.Hudson.READ,'anonymous')
    instance.setAuthorizationStrategy(strategy)
    instance.save()
  EOH
  #notifies :create, 'ruby_block[set the security_enabled flag]', :immediately
  action :nothing
end


#ruby_block 'set the security_enabled flag' do
#  block do
#    node.run_state[:jenkins_private_key] = 'private_key'
#    node.set['security_enabled'] = true
#    node.save
#  end
#  action :nothing
#end

