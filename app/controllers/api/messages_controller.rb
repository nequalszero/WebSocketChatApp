class Api::MessagesController < ApplicationController
  before_action :verify_chatroom_membership, only: [:index, :create]
  before_action :verify_logged_in_and_message_existance, only: [:update]

  def index
    @messages = get_chatroom_messages()
    render json: @messages.map(&:serialize)
  end

  def create
    @message = Message.new(new_message_params)

    if @message.save
      render json: @message.serialize
    else
      render json: @message.errors.full_messages, status: 422
    end
  end

  def update
    # @message = Message.find(params[:id])
    validate_message_ownership; return if performed?

    if @message.update(message_params)
      render json: @message.serialize
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

  def get_chatroom_messages
    @chatroom_member.chatroom.messages
  end

  def verify_chatroom_existance
    render json: ["Unprocessible entity - chatroom does not exist"], status: 422 unless Chatroom.exists?(params[:chatroom_id])
  end

  def verify_logged_in_and_message_existance
    require_logged_in; return if performed?
    @message = Message.find_by(id: params[:id])
    render json: ["Unprocessible entity - Message id: #{params[:id]} does not exist"], status: 422 unless @message
  end

  def verify_chatroom_membership
    require_logged_in; return if performed?
    verify_chatroom_existance; return if performed?
    @chatroom_member = ChatroomMember.find_chatroom_member(current_user.id, params[:chatroom_id])
    render json: ["Access forbidden - no chatroom access"], status: 403 unless @chatroom_member
  end

  def validate_message_ownership
    render json: ["Access forbidden - unauthorized to update message with id: #{params[:id]}"], status: 403 unless @message.user_id == current_user.id
  end
end
