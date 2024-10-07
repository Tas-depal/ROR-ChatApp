# frozen_string_literal: true

# Users controller
class UsersController < ApplicationController
  def add_members
    channel = Channel.find_by_id(params[:channel_id])
    ids = User.where(username: params[:selected_user]).pluck(:id)
    add_members_to_channel(ids, channel, channel.member_ids)   
    redirect_to channel_path(params[:channel_id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by_id(params[:id].to_i)
  end

  def update
    @user = User.find_by_id(params[:id].to_i)
    if @user.update(user_params)
      redirect_to channels_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

private

  def add_members_to_channel(ids, channel, channel_member_ids)
    ids.each do |id|
      channel_member_ids += [id]
      @last_read_msg = channel.last_read
      @room_presence = channel.room_presence
      @last_read_msg[id] = Time.now
      @room_presence[id] = false
      channel.add_member = true
    end
    channel.update(member_ids: channel_member_ids, last_read: @last_read_msg, room_presence: @room_presence) 
  end

  def user_params
    params.require(:user).permit(:username, :email, :password_digest)
  end
end
