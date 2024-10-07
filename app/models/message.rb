# frozen_string_literal: true

# Message model
class Message < ApplicationRecord
  attr_accessor :files

  after_create_commit :broadcast_message
  belongs_to :user
  belongs_to :channel
  has_many_attached :attachments, dependent: :destroy

  private

  def broadcast_message
    msg_broadcast
    private_channel_msg
    notify_new_msg
  end

  def msg_broadcast
    attachments.attach(files) if files.present?
    broadcast_append_to channel
  end

  def notify_new_msg
    channel.member_ids.each do |member_id|
      next if member_id == user_id
      broadcast_append_to "notification_#{member_id}", partial: 'partials/notification',
                                                       locals: { message: 'New message' }
      unless channel.room_presence[member_id.to_s]
        msg_count = channel.messages.where('created_at > ? AND user_id != ?', channel.last_read[member_id.to_s]&.to_time,
                                         member_id).count
      else
        msg_count = 0
      end
      update_msg_count(member_id, msg_count)
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

  def update_msg_count(member_id, msg_count)
    broadcast_append_to "msg_count_#{channel.id}_#{member_id}",
                        partial: 'partials/message_count',
                        locals: { msg_count: },
                        target: "show_message_count"
  end

end
