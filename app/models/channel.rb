class Channel < ApplicationRecord

  attr_accessor :member_id

  has_many :messages, dependent: :destroy
  validates_uniqueness_of :channel_name
  scope :public_channels, -> { where(is_private: false) }
  after_update_commit :broadcast_channel

  def broadcast_channel
    unless self.is_private
      broadcast_append_to "channels_#{member_id}"
    end
  end
  
end
