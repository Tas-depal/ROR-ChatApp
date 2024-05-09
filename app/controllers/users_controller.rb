# frozen_string_literal: true

# Users controller
class UsersController < ApplicationController

  def add_members
    channel = Channel.find_by_id(params[:channel_id])
    member_ids = channel.member_ids
    ids = User.where(username: params[:selected_user]).pluck(:id)
    ids.each do |id|
      member_ids += [id]
      last_read = channel.last_read
      last_read[id] = Time.now
      channel.member_id = id
      channel.add_member = true
      channel.update(member_ids: member_ids, last_read: last_read)
    end
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

  def user_params
    params.require(:user).permit(:username, :email, :password_digest)
  end
end
