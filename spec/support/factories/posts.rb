require 'factory_girl'

Factory.define :post do |p|
  p.chat_input "hello, world!"
  p.association :user
end