template "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageA_Compile.xml" do
  source 'Continuous_Delivery_StageA_Compile.xml.erb'
 end

 jenkins_job 'Continuous_Delivery_StageA_Compile' do
   config "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageA_Compile.xml"
 end

template "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageB_UnitTest.xml" do
  source 'Continuous_Delivery_StageB_UnitTest.xml.erb'
 end

 jenkins_job 'Continuous_Delivery_StageB_UnitTest' do
   config "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageB_UnitTest.xml"
 end

template "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageC_SCA.xml" do
  source 'Continuous_Delivery_StageC_SCA.xml.erb'
 end

 jenkins_job 'Continuous_Delivery_StageC_SCA' do
   config "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageC_SCA.xml"
 end


template "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageD_Packaging.xml" do
  source 'Continuous_Delivery_StageD_Packaging.xml.erb'
 end

 jenkins_job 'Continuous_Delivery_StageD_Packaging' do
   config "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageD_Packaging.xml"
 end

template "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageE_DeployST.xml" do
  source 'Continuous_Delivery_StageE_DeployST.xml.erb'
 end

 jenkins_job 'Continuous_Delivery_StageE_DeployST' do
   config "#{node['jenkins']['master']['home']}/Continuous_Delivery_StageE_DeployST.xml"
 end

