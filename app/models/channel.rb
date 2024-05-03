class Channel < ApplicationRecord

  attr_accessor :member_id, :add_member, :remove_member

  has_many :messages, dependent: :destroy
  validates :channel_name, presence: :true, uniqueness: true
  scope :public_channels, -> { where(is_private: false) }
  after_update_commit :broadcast_channel

  private
  
  def broadcast_channel
    unless self.is_private
      broadcast_append_to "channels_#{member_id}"
      if add_member
        self.member_ids.each do |member|
          next if member == member_id
          user = User.find_by_id(member).username
          broadcast_append_to "add_member_to_channel#{member}",
                          target: 'add_member',
                          partial: 'partials/add_member',
                          locals: { user: user, member_id: member, channel_id: self.id }
        end
      end
    end
  end  
end
