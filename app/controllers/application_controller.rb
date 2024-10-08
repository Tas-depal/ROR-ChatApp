class ApplicationController < ActionController::Base
  helper_method :current_user

  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end

  def current_user
    if session[:user_id]
      @current_user  = User.find(session[:user_id])
    end
  end

  def log_in(user)
    session[:user_id] = user.id
    @current_user = user
    channel = Channel.find_by(channel_name: user.username)
    channel = Channel.create(channel_name: user.username, is_private: true, member_ids: [user.id], creator_id: [user.id], last_read: {user.id.to_s=> Time.now}, room_presence: {user.id.to_s=> true}) unless channel.present?
    redirect_to channel_path(channel.id)
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
end
