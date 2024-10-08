class Broadcast < ApplicationRecord
    belongs_to :channel
    belongs_to :user
    enum broadcast_type: [:new_msg, :new_channel, :new_user, :new_msg_private, :new_channel_private, :new_user_private]
    
end
