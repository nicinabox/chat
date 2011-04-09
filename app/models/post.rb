class Post < ActiveRecord::Base
  belongs_to :user
  validates_associated :user
  validates :chat_input, :presence => true
end
