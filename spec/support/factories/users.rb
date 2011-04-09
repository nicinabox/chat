require 'factory_girl'

Factory.define :user do |u|
  u.login "joemsak"
  u.twitter_id "14504925"
  u.name "Joe M. Sak"
end