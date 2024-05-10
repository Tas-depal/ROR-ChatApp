# frozen_string_literal: true

# Channel model
class Channel < ApplicationRecord
  attr_accessor :member_id, :add_member, :remove_member

  has_many :messages, dependent: :destroy
  validates :channel_name, presence: true, uniqueness: true
  scope :public_channels, -> { where(is_private: false) }
  after_update_commit :broadcast_channel

  private

  def add_and_update_channel_members(member, username)
    broadcast_append_to "add_member_to_channel_#{member}",
                        target: 'add_member',
                        partial: 'partials/add_member',
                        locals: { user: username, member_id: member, channel_id: id }
    broadcast_replace_to "update_member_count_#{member}",
                         target: 'member_count',
                         partial: 'partials/members_count',
                         locals: { msg_count: member_ids.count }
  end

  def broadcast_added_members
    broadcast_append_to "channels_#{member_id}"
    user = User.find_by_id(member_id).username
    member_ids.each do |member|
      next if member == member_id

      add_and_update_channel_members(member, user)
    end
  end

  def broadcast_channel
    return if is_private

    if add_member
      broadcast_added_members
    elsif remove_member
      broadcast_append_to "remove_channels_#{member_id}", partial: 'partials/remove_channel'
      member_ids.each do |member|
        broadcast_append_to "remove_channels_#{member}", partial: 'partials/remove_channel'
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
