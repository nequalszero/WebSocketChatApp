class Api::ChatroomMembersController < ApplicationController
  before_action :require_logged_in, only: [:create, :destroy]

  def create
    @chatroom_member = ChatroomMember.new(chatroom_member_params)

    if @chatroom_member.save
      render json: ChatroomMember.serialize(@chatroom_member)
    else
      render json: @chatroom_member.errors.full_messages, status: 422
    end
  end

  def destroy
    @chatroom_member = ChatroomMember.find_by(id: params[:id])

    if @chatroom_member
      validate_ownership; return if performed?
      @chatroom_member.delete
      render json: @chatroom_member
    else
      render json: ["Unprocessible entity - chatroom member with id #{params[:id]} does not exist"], status: 422
    end
  end

  private
  def chatroom_member_params
    { user_id: current_user.id, chatroom_id: params[:chatroom_id] }
  end

  # Ensure current_user.id matches @chatroom_member.user_id
  def validate_ownership
    render json: ["Unauthorized action - current user is not the chatroom member"], status: 403 unless current_user.id == @chatroom_member.id
  end
end
