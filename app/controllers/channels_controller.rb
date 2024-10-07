# frozen_string_literal: true

# Channels controller
class ChannelsController < ApplicationController
  before_action :find_current_user
  before_action :display_channels, only: %i[show index]
  before_action :show_users, only: %i[show index]

  def create
    if params[:is_private]
      if params[:selected_user].present?
        create_private_channel
      else
        create_personal_channel
      end
    else
      create_group_chat
    end
  end

  def index
    redirect_to root_path unless current_user
  end

  def new
    @channels = Channel.new
  end

  def remove_group_member
    channel = Channel.find_by_id(params[:channel_id])
    member_id = channel.member_ids
    member_id.delete(params[:member_id].to_i)
    channel.member_id = params[:member_id].to_i
    channel.remove_member = true
    channel.update(member_ids: member_id)
  end

  def show
    @single_room = Channel.find_by_id(params[:id])
    if @single_room.present? && @single_room.member_ids.include?(@current_user.id)
      update_last_read
      @message = Message.new
      @messages = @single_room&.messages
      render 'index'
    else
      redirect_to not_found_path
    end
  end

  private

  def create_group_chat
    @channels = Channel.create(create_params(params['channel_name']))
    redirect_to channel_path(@channels.id) if @channels.save
  end

  def create_params(name, is_pvt: false)
    {
      channel_name: name,
      member_ids: [session[:user_id]],
      creator_id: session[:user_id],
      is_private: is_pvt,
    }
  end

  def create_personal_channel
    @channels = Channel.find_by(channel_name: @current_user.username)
    @channels = Channel.create(create_params(@current_user.username, is_pvt: true)) unless @channels.present?
    redirect_to channel_path(@channels.id)
  end

  def create_private_channel
    @channels = Channel.find_by(channel_name: get_channel_name(@current_user&.username, params[:selected_user][0]))
    @channels = Channel.create(create_private_channel_params) unless @channels.present?
    redirect_to channel_path(@channels.id)
  end

  def create_private_channel_params
    {
      channel_name: get_channel_name(@current_user&.username, params[:selected_user][0]),
      is_private: true,
      member_ids: [session[:user_id], find_user],
      last_read: { session[:user_id].to_s => Time.now, find_user.to_s => Time.now },
      room_presence: { @current_user.id.to_s => true, find_user.to_s => false }
    }
  end

  def display_channels
    @channels = Channel.public_channels&.where('? = ANY(member_ids)', @current_user&.id)
    @direct_messages = Channel.where('? = ANY(member_ids) AND ? = is_private', @current_user&.id, true)
  end

  def find_current_user
    @current_user = current_user
  end

  def find_user
    User.find_by_username(params[:selected_user]).id
  end

  def get_channel_name(user1, user2)
    [user2, user1].sort.join(',')
  end

  def show_users
    @users = User.all_except(@current_user)
  end

  def update_last_read

    update_room_presence

    last_read = @single_room.last_read
    last_read[@current_user.id.to_s] = Time.now
    @single_room.update!(last_read:)
  end

  def update_room_presence
    current_user_channel_ids = Channel.pluck(:id, :member_ids).select { |array| array[1].include?(@current_user.id) }.map { |array| array[0] }
    current_user_channels = Channel.where(id: current_user_channel_ids)
    current_user_channels.each do |channel|
      room_presence = channel.room_presence
      if channel == @single_room
        room_presence[@current_user.id.to_s] = true
      else
        room_presence[@current_user.id.to_s] = false
      end
      channel.update(room_presence:)
    end
  end
end
