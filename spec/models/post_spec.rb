require 'spec_helper'

describe Post do
  before(:each) do
    @post = Factory(:post)
  end
  
  it "can instantiate" do
    @post.should_not be_nil
  end
  
end