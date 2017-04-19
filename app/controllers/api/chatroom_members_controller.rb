class Api::ChatroomMembersController < ApplicationController
  before_action :verify_logged_in_and_chatroom_existance, only: [:create]
  before_action :require_logged_in, only: [:destroy]

  def create
    @chatroom_member = ChatroomMember.new(chatroom_member_params)

    if @chatroom_member.save
      render json: @chatroom_member.serialize
    else
      render json: @chatroom_member.errors.full_messages, status: 422
    end
  end

  def destroy
    find_chatroom_member; return if performed?
    validate_ownership; return if performed?
    mark_as_left
    render json: @chatroom_member.serialize
  end

  private

  def chatroom_member_params
    { user_id: current_user.id, chatroom_id: params[:chatroom_id] }
  end

  def find_chatroom_member
    @chatroom_member = ChatroomMember.find_by(id: params[:id])
    render json: ["Unprocessible entity - chatroom member with id: #{params[:id]} does not exist"], status: 422 unless @chatroom_member
  end

  def mark_as_left
    @chatroom_member.update(has_left: true)
    @chatroom_member.save
  end

  def verify_logged_in_and_chatroom_existance
    require_logged_in; return if performed?
    render json: ["Unprocessible entity - chatroom does not exist"], status: 422 unless Chatroom.exists?(params[:chatroom_id])
  end

  # Ensure current_user.id matches @chatroom_member.user_id
  def validate_ownership
    render json: ["Unauthorized action - current user is not the chatroom member"], status: 403 unless current_user.id == @chatroom_member.user_id
  end
end
