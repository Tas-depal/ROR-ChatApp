# frozen_string_literal: true

# Channel model
class Channel < ApplicationRecord
  attr_accessor :member_id, :add_member, :remove_member

  has_many :messages, dependent: :destroy
  has_many :broadcasts, dependent: :destroy

  validates :channel_name, presence: true, uniqueness: true
  scope :public_channels, -> { where(is_private: false) }
  after_update_commit :broadcast_channel

  private


  def broadcast_channel
    return if is_private

    if add_member || remove_member
      user = User.find_by_id(member_id)
      if user.present?
        personal_channel = Channel.find_by(channel_name: user.username)&.id
        personal_channel = Channel.create(channel_name: user.username, is_private: true, member_ids: [user.id], creator_id: [user.id], last_read: {user.id.to_s=> Time.now}, room_presence: {user.id.to_s=> Time.now})&.id unless personal_channel.present?
        broadcast_append_to "add_remove_channels_#{member_id}", partial: 'partials/add_remove_channel', locals: { remove: 'true', channel_id: id, personal_channel: }
      end
      member_ids.each do |member|
        broadcast_append_to "add_remove_channels_#{member}", partial: 'partials/add_remove_channel', locals: { remove: 'false', channel_id: id, personal_channel: '' }
      end
    end
    update_attr_accessor
  end

  def update_attr_accessor
    self.add_member = false
    self.remove_member = false
    self.member_id = nil
  end
end
