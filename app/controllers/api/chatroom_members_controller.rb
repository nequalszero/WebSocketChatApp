class Api::ChatroomMembersController < ApplicationController
  before_action :verify_logged_in_and_chatroom_existance, only: [:index, :create]
  before_action :require_logged_in, only: [:destroy]

  def index
    render json: @chatroom.chatroom_members.map(&:serialize)
  end

  def create
    @chatroom_member = ChatroomMember.find_by({user_id: current_user.id, chatroom_id: params[:chatroom_id]})

    if @chatroom_member
      handle_existing_chatroom_member; return if performed?
    else
      handle_new_chatroom_member; return if performed?
    end
  end

  def destroy
    find_chatroom_member; return if performed?
    validate_ownership; return if performed?
    validate_has_left; return if performed?
    @chatroom_member.update(has_left: true)

    if @chatroom_member.save
      render json: @chatroom_member.serialize
    else
      render json: @chatroom_member.errors.full_messages
    end
  end

  private

  def chatroom_member_params
    { user_id: current_user.id, chatroom_id: params[:chatroom_id] }
  end

  def find_chatroom_member
    @chatroom_member = ChatroomMember.find_by(id: params[:id])
    render json: ["Unprocessible entity - chatroom member with id: #{params[:id]} does not exist"], status: 422 unless @chatroom_member
  end

  def verify_logged_in_and_chatroom_existance
    require_logged_in; return if performed?
    @chatroom = Chatroom.includes(:chatroom_members).find_by(id: params[:chatroom_id])
    render json: ["Unprocessible entity - chatroom does not exist"], status: 422 unless @chatroom
  end

  # Ensure current_user.id matches @chatroom_member.user_id
  def validate_ownership
    render json: ["Unauthorized action - current user is not the chatroom member"], status: 403 unless current_user.id == @chatroom_member.user_id
  end

  def validate_has_left
    render json: ["Unprocessible entity - chatroom member has already been marked as left"], status: 422 if @chatroom_member.has_left
  end

  # Checks an existing chatroom member to verify the user_id matches the current_user
  # Render error if the ids do not match, and if the has_left attribute is false
  def validate_ownership_and_membership_status
    validate_ownership; return if performed?
    render json: ["Unprocessible entity - user is still a member of the chatroom, cannot re-add"], status: 422 unless @chatroom_member.has_left
  end

  # Handles chatroom member creation if no entry already exists for the requested
  # chatroom and current user id.
  def handle_new_chatroom_member
    @chatroom_member = ChatroomMember.new(chatroom_member_params)
    save_chatroom_member
  end

  # Handles chatroom member creation if an entry already exists for the requested
  # chatroom and current user id.
  def handle_existing_chatroom_member
    validate_ownership_and_membership_status; return if performed?
    @chatroom_member.update(has_left: false)
    save_chatroom_member
  end

  def save_chatroom_member
    if @chatroom_member.save
      render json: @chatroom.serialize_for_current_user(current_user)
    else
      render json: @chatroom_member.errors.full_messages, status: 422
    end
  end
end
