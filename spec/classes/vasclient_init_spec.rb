require 'spec_helper'

describe 'vasclient', :type => :class do

  let(:params) do { 
    :enable   => 'true',
    :password => 'randompass',
    :package  => 'vasclnt',
  }
  end

  it { is_expected.to compile }
  it { is_expected.to compile.with_all_deps}
  it { 
    should contain_package('vasclnt').with({
      'ensure'    => 'present',
    })
    should contain_service('vasd').with({
      'ensure' => 'running',
    })
  }
end
