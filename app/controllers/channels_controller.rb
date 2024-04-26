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

  def show
    @single_room = Channel.find_by_id(params[:id])
    @room = Channel.new
    @message = Message.new
    @messages = @single_room&.messages
    render 'index'
  end

  private

  def create_private_channel
    @channels = Channel.create(create_private_channel_params)
    unless @channels.save
      @channels = Channel.find_by(channel_name: get_channel_name(@current_user&.username, params[:selected_user][0]))
    end
    redirect_to channel_path(@channels.id)
  end

  def create_group_chat
    @channels = Channel.create(create_params(params['channel_name']))
    if @channels.save
      redirect_to channel_path(@channels.id)
    else
      @error_message = @channels.errors.full_messages[0]
    end
  end

  def create_personal_channel
    @channels = Channel.create(create_params(@current_user.username, true))
    unless @channels.save
      @channels = Channel.find_by(channel_name: @current_user.username)
    end
    redirect_to channel_path(@channels.id)
  end

  def find_current_user
    @current_user = current_user
  end

  def display_channels
    @channels = Channel.public_channels&.where('? = ANY(member_ids)', @current_user&.id)
    @direct_messages = Channel.where('? = ANY(member_ids) AND ? = is_private', @current_user&.id, true)
    @notifications = []
  end

  def find_user
    User.find_by_username(params[:selected_user]).id
  end

  def create_private_channel_params
    {
      channel_name: get_channel_name(@current_user&.username, params[:selected_user][0]),
      is_private: true,
      member_ids: [session[:user_id], find_user]
    }
  end

  def create_params(channel_name, is_private=false)
    {
      channel_name: channel_name,
      member_ids: [session[:user_id]],
      creator_id: session[:user_id],
      is_private: is_private
    }
  end

  def get_channel_name(user1, user2)
    [user2, user1].sort.join(',')
  end

  def show_users
    @users = User.all_except(@current_user)
  end
end
