class Channel < ApplicationRecord

  attr_accessor :member_id, :add_member, :remove_member

  has_many :messages, dependent: :destroy
  validates :channel_name, presence: :true, uniqueness: true
  scope :public_channels, -> { where(is_private: false) }
  after_update_commit :broadcast_channel

  private
  
  def broadcast_channel
    unless self.is_private
      if add_member
        broadcast_append_to "channels_#{member_id}"
        user = User.find_by_id(member_id).username
        self.member_ids.each do |member|
          next if member == member_id
          broadcast_append_to "add_member_to_channel_#{member}",
                          target: "add_member",
                          partial: 'partials/add_member',
                          locals: { user: user, member_id: member, channel_id: self.id }
        end
      # elsif remove_member
      #   broadcast_remove_to("remove_channels_#{member_id}")
      end
      self.add_member = false
      self.remove_member = false
      self.member_id = nil
    end
  end  
end
