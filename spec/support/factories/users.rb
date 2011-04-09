require 'factory_girl'

Factory.define :user do |u|
  u.login "joemsak"
  u.sequence(:twitter_id) { |n| "778272#{n}" }
end