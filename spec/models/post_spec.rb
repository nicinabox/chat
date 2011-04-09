require 'spec_helper'

describe Post do
  
  it "requires chat input" do
    User.delete_all
    Post.delete_all
    Post.new.should_not be_valid
    Post.new(:chat_input => "Hi!", :user => Factory(:user)).should be_valid
  end
end