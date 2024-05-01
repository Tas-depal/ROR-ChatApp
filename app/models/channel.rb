class Channel < ApplicationRecord

  attr_accessor :member_id, :user_id

  has_many :messages, dependent: :destroy
  validates_uniqueness_of :channel_name
  scope :public_channels, -> { where(is_private: false) }
  after_update_commit :broadcast_channel

  private
  
  def broadcast_channel
    unless self.is_private
      broadcast_append_to "channels_#{member_id}"
      if self.messages.present?
        self.member_ids.each do |member_id|
          next if member_id == user_id
          msg_count = self.messages.where("created_at > ? AND user_id != ?", (self.last_read["#{member_id}"]).to_time, member_id).count
          if self.is_private
            private_channel_msg_count(member_id, msg_count)
          else
            public_channel_msg_count(member_id, msg_count)
          end
        end
      end
    end
  end

  def private_channel_msg_count(member_id, msg_count)
    broadcast_append_to "private_msg_count_#{member_id}",
                        partial: 'partials/private_message_count',
                        locals: { msg_count: msg_count },
                        target: "show_private_message_count_#{ self.id }"
  end

  def public_channel_msg_count(member_id, msg_count)
    broadcast_append_to "public_msg_count_#{member_id}",
                        partial: 'partials/public_message_count',
                        locals: { msg_count: msg_count },
                        target: "show_public_message_count_#{ self.id }"
  end
  
end
