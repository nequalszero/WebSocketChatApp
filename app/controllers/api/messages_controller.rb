class Api::MessagesController < ApplicationController
  before_action :require_logged_in, only: [:create, :update]

  def create
    verify_chatroom_membership
    @message = message.new(new_message_params)

    if @message.save
      render json: @message
    else
      render json: @message.errors.full_messages, status: 422
    end
  end

  def update
    @message = Message.find(params[:id])
    validate_ownership(@message)

    if @message.update(new_message_params)
      render json: @message
    else
      render json: @message.errors.full_messages, status: 422
    end
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end

  def new_message_params
    message_params.merge(user_id: current_user.id, chatroom_id: params[:chatroom_id])
  end

  def verify_chatroom_membership
    render json: ["Access forbidden"], status: 403 unless ChatroomMember.find_chatroom_member(current_user.id, params[:chatroom_id])
  end

  def validate_ownership(message)
    render json: ["Access forbidden - unauthorized"], status: 403 unless message.user_id == current_user.id
    render json: ["Access forbidden - incorrect chatroom"], status: 422 unless message.chatroom_id == params[:chatroom_id]
  end
end
