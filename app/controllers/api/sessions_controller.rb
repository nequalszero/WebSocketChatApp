class Api::SessionsController < ApplicationController
  before_action :require_logged_in, only: [:destroy]

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user
      sign_in(@user)
      render json: new_session_response
    else
      render(
        json: ["Invalid username/password combination"],
        status: 401
      )
    end
  end

  def destroy
    @user = current_user
		sign_out
		render json: @user.serialize
  end

  private
  def new_session_response
    @user.serialize_current_user.merge({nonUserChatrooms: Chatroom.non_user_chatrooms(@user)})
  end
end
