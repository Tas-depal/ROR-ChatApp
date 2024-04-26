class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  after_create_commit :broadcast_message

  private
  def broadcast_message
    broadcast_append_to self.channel 
    if self.channel.is_private
      if self.channel.messages.count == 1
        other_member_id = self.channel.member_ids.select{|id| id!=user.id}[0]
        broadcast_append_to "direct_messages#{other_member_id}", target: "direct_messages_list", partial: 'partials/direct_message', locals: { direct_message: self.channel, user: user }
      end
    end
    self.channel.member_ids.each do |member_id|
      unless member_id == self.user_id
        broadcast_append_to "notification_#{member_id}", partial: 'partials/notification', locals: { message: 'New message' }
      end
    end
  end
end
