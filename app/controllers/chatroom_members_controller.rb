class ChatroomMembersController < ApplicationController
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
    @chatroom_member = ChatroomMember.find_by(chatroom_member_params)

    if @chatroom_member
      @chatroom_member.delete
      render json: @chatroom_member
    else
      render json: ["Not a member of this chatroom"], status: 422
    end

  end

  private
  def chatroom_member_params
    { user_id: current_user.id, chatroom_id: params[:chatroom_id] }
  end

  def
end
