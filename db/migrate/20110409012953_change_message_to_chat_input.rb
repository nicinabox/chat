class ChangeMessageToChatInput < ActiveRecord::Migration
  def self.up
    rename_column :posts, :message, :chat_input
  end

  def self.down
    rename_column :post, :chat_input, :message
  end
end
