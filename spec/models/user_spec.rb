require 'spec_helper'

describe User do
  
  before(:each) do
    @user = Factory(:user)
  end
  
  it "should instantiate" do
    @user.should_not be_nil
  end
end
