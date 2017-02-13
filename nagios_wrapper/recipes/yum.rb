ruby_block "enable kernel updates" do
  block do
    file = Chef::Util::FileEdit.new("/etc/yum.conf")
    file.search_file_replace( "/exclude=kernel* redhat-release*/", "exclude=redhat-release*")
    file.write_file
  end
end

