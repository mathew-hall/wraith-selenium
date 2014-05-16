require 'rspec'

require_relative "../lib/wraith"
require_relative "lib/spec_lib"


describe 'Wraith Module' do

  before(:all) do
    include Wraith
  end

  it 'check that the cli component is  auto-loaded' do
    Wraith.constants.include?(:CLI).should == true
  end

  it 'check that the error component is auto-loaded' do
    Wraith.constants.include?(:Error).should == true
  end

  # it 'check that the Wraith component is not auto-loaded' do
  #   Wraith.constants.include?(:Wraith).should == false
  # end

end