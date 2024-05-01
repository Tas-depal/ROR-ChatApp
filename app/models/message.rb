# frozen_string_literal: true

# Message model
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to channel
    private_channel_msg
    notify_new_msg
  end

  def notify_new_msg
    channel.member_ids.each do |member_id|
      next if member_id == user_id
      broadcast_append_to "notification_#{member_id}", partial: 'partials/notification',
                                                       locals: { message: 'New message' }
      msg_count = channel.messages.where("created_at > ? AND user_id != ?", (channel.last_read["#{member_id}"]).to_time, member_id).count
      if channel.is_private
        private_channel_msg_count(member_id, msg_count)
      else
        public_channel_msg_count(member_id, msg_count)
      end
    end
  end

  def private_channel_msg
    return unless channel.is_private
    return unless channel.messages.count == 1

    other_member_id = channel.member_ids.reject { |id| id == user.id }[0]
    broadcast_append_to "direct_messages#{other_member_id}",
                        target: 'direct_messages_list',
                        partial: 'partials/direct_message',
                        locals: { direct_message: channel, user: }
  end

  def private_channel_msg_count(member_id, msg_count)
    broadcast_append_to "private_msg_count_#{member_id}",
                        partial: 'partials/private_message_count',
                        locals: { msg_count: msg_count },
                        target: "show_private_message_count_#{ channel.id }"
  end

  def public_channel_msg_count(member_id, msg_count)
    broadcast_append_to "public_msg_count_#{member_id}",
                        partial: 'partials/public_message_count',
                        locals: { msg_count: msg_count },
                        target: "show_public_message_count_#{ channel.id }"
  end
end
