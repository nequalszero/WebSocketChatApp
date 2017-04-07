module Api::SessionsHelper
  def current_user
    User.find_by_session_token(session[:session_token])
  end

	def create_session(user)
   	session[:session_token] = user.reset_session_token!
 	end

 	def destroy_session(user)
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
 	end
end
