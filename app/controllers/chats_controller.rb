class ChatsController < ApplicationController
  before_filter :login_required
  protect_from_forgery :except => :post
  respond_to :json

  def index
   @posts = Post.order('created_at DESC')
  end
  
  def send_data
    @post = Post.create(params.slice(:user_id, :chat_input))
    post_data = {
      :command   => :broadcast,
      :body      => params[:chat_input],
      :type      => :to_channels_without_signature, 
      :channels  => 'groupon_go'
    }
    Pusher['groupon_go'].trigger!('new_post', post_data)
    #render :juggernaut => {:type => :send_to_channels, :channels => ['web']} do |page|
    #  page.insert_html :top, 'chat_data', "<li>#{h params[:chat_input]}</li>"
    #end
    render :nothing => true
  end
  
end


