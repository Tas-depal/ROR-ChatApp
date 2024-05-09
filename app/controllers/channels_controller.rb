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
    redirect_to channel_path(params[:channel_id])
  end

  def show
    @single_room = Channel.find_by_id(params[:id])
    unless @single_room.nil?
      update_last_read
      @message = Message.new
      @messages = @single_room&.messages
    end
    render 'index'
  end

  private

  def create_group_chat
    @channels = Channel.create(create_params(params['channel_name']))
    redirect_to channel_path(@channels.id) if @channels.save
  end

  def create_params(name, is_pvt = false)
    {
      channel_name: name,
      member_ids: [session[:user_id]],
      creator_id: session[:user_id],
      is_private: is_pvt
    }
  end

  def create_personal_channel
    @channels = Channel.find_by(channel_name: @current_user.username)
    unless @channels.present?
      @channels = Channel.create(create_params(@current_user.username, true))
    end
    redirect_to channel_path(@channels.id)
  end

  def create_private_channel
    @channels = Channel.find_by(channel_name: get_channel_name(@current_user&.username, params[:selected_user][0]))
    unless @channels.present?
      @channels = Channel.create(create_private_channel_params)
    end
    redirect_to channel_path(@channels.id)
  end

  def create_private_channel_params
    {
      channel_name: get_channel_name(@current_user&.username, params[:selected_user][0]),
      is_private: true,
      member_ids: [session[:user_id], find_user]
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
    return unless params[:last_read_at].present?

    if @single_room.last_read.empty?
      @single_room.update!(last_read: { @current_user.id => params[:last_read_at] })
    else
      last_read = @single_room.last_read
      last_read[@current_user.id] = params[:last_read_at]
      @single_room.update!(last_read:)
    end
  end
end
