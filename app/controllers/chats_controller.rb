class ChatsController < ApplicationController
  before_filter :login_required
  protect_from_forgery :except => :post
  respond_to :json
  include ApplicationHelper
  delegate :link_to, :auto_link, :sanitize, :to => 'ActionController::Base.helpers'

  def index
   @posts = Post.order('created_at DESC')
  end
  
  def send_data
    @post = Post.create(params.slice(:user_id, :chat_input))
    post_data = {
      :command           => :broadcast,
      :body              => sanitize(auto_link(auto_image(params[:chat_input])), :tags => %w(a img), :attributes => %w(href src alt)),
      :name              => current_user.name,
      :profile_image_url => current_user.profile_image_url,
      :twitter_login     => current_user.twitter_login,
      :type              => :to_channels_without_signature, 
      :channels          => 'groupon_go'
    }
    Pusher['groupon_go'].trigger!('new_post', post_data)
    #render :juggernaut => {:type => :send_to_channels, :channels => ['web']} do |page|
    #  page.insert_html :top, 'chat_data', "<li>#{h params[:chat_input]}</li>"
    #end
    render :nothing => true
  end
  
end

