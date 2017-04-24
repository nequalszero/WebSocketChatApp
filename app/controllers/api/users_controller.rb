class Api::UsersController < ApplicationController
  def create
		@user = User.new(user_params)

		if @user.save
			sign_in(@user)
      # render "api/users/show"
			render json: new_session_response
		else
			render json: @user.errors.full_messages, status: 422
		end
	end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end

  def new_session_response
    @user.serialize_current_user.merge({nonUserChatrooms: Chatroom.non_user_chatrooms(@user)})
  end
end
