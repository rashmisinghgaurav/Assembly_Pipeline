template "#{node['jenkins']['master']['home']}/stage1-job-config.xml" do
  source 'stage1-job-config.xml.erb'
 end

 jenkins_job 'Continuous_Delivery_Stage1_Build' do
   config "#{node['jenkins']['master']['home']}/stage1-job-config.xml"
 end

