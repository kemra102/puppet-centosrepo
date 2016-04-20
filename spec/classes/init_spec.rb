require 'spec_helper'
describe 'centosrepo' do

  context 'with default values for all parameters' do
    it {
      should contain_class('centosrepo')
      #should contain_file('/etc/yum.repos.d').with({
      #  'ensure'  => 'directory',
      #  'recurse' => 'true',
      #  'purge'   => 'true'
      #})
    }
  end

end
