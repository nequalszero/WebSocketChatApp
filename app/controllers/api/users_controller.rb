class Api::UsersController < ApplicationController
  def create
		@user = User.new(user_params)

		if @user.save
			sign_in(@user)
      # render "api/users/show"
			render json: User.serialize(@user)
		else
			render json: @user.errors.full_messages, status: 422
		end
	end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
