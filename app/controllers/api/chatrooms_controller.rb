class Api::ChatroomsController < ApplicationController
  before_action :require_logged_in, only: [:index, :create]

  def index
    render json: current_user.non_user_chatrooms
  end

  def create
    @chatroom = Chatroom.new(chatroom_params)

    if @chatroom.save
      ChatroomMember.create(user_id: current_user.id, chatroom_id: @chatroom.id)
      render json: @chatroom
    else
      render json: @chatroom.errors.full_messages, status: 422
    end
  end

  # def update
  #   @chatroom = Chatroom.find(params[:id])
  #
  #   if @chatroom.update(chatroom_params)
  #     render json: @chatroom
  #   else
  #     render json: @chatroom.errors.full_messages, status: 422
  #   end
  # end

  private
  def chatroom_params
    params.require(:chatroom).permit(:name)
  end
end
