require 'spec_helper'

describe User do
  
  before(:each) do
    @user = Factory(:user)
  end
  
  it "should instantiate" do
    @user.should_not be_nil
  end
  
  it "should have a name from twitter, I guess?" do
    @user.name.should_not be_nil
  end
end
