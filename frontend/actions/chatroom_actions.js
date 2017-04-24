import * as APIUtil from '../util/chatroom_api_util';

export const RECEIVE_NEW_MESSAGE = "RECEIVE_NEW_MESSAGE";
export const RECEIVE_UPDATED_MESSAGE = "RECEIVE_UPDATED_MESSAGE";
export const RECEIVE_CHATROOM_MESSAGES = "RECEIVE_CHATROOM_MESSAGES";
export const RECEIVE_NON_USER_CHATROOMS = "RECEIVE_NON_USER_CHATROOMS";
export const RECEIVE_USER_CHATROOMS = "RECEIVE_USER_CHATROOMS";
export const RECEIVE_USER_CHATROOM = "RECEIVE_USER_CHATROOM";
export const RECEIVE_CHATROOM_ERROR = "RECEIVE_CHATROOM_ERROR";
export const CLEAR_CHATROOMS = "CLEAR_CHATROOMS";
export const SELECT_CURRENT_CHATROOM = "SELECT_CURRENT_CHATROOM";

// Constants for error handling
export const JOIN_CHATROOM = "JOIN_CHATROOM";
export const CREATE_CHATROOM = "CREATE_CHATROOM";
export const CREATE_NEW_MESSAGE = "CREATE_NEW_MESSAGE";

export const joinChatroom = (chatroomId) => dispatch => {
  return APIUtil.createChatroomMember(chatroomId)
    .then(
      (data) => dispatch(receiveUserChatroom(data)),
      (error) => dispatch(receiveUserChatroomError(error, JOIN_CHATROOM))
    )
}

// Accepts a single chatroom
export const receiveUserChatroom = (chatroom) => ({
  type: RECEIVE_USER_CHATROOM,
  chatroom
})

// Accepts an array of chatrooms
export const receiveUserChatrooms = (chatrooms) => ({
  type: RECEIVE_USER_CHATROOMS,
  chatrooms
})

export const clearChatrooms = () => ({
  type: CLEAR_CHATROOMS
})

// Accepts an array of chatrooms
export const receiveNonUserChatrooms = (chatrooms) => ({
  type: RECEIVE_NON_USER_CHATROOMS,
  chatrooms
})

export const receiveUserChatroomError = (error, errorType) => ({
  type: RECEIVE_CHATROOM_ERROR,
  errorType,
  error
})

export const createChatroom = (name) => dispatch => {
  return APIUtil.createChatroom(name)
    .then(
      (data) => dispatch(receiveUserChatroom(data)),
      (error) => dispatch(receiveUserChatroomError(error, CREATE_CHATROOM))
    )
}

export const selectCurrentChatroom = (chatroomId) => ({
  type: SELECT_CURRENT_CHATROOM,
  chatroomId
})

export const createMessage = ({chatroomId, body}) => dispatch => {
  return APIUtil.createMessage({chatroomId, body})
    .then(
      (data) => dispatch(receiveNewMessage(data)),
      (error) => dispatch(receiveUserChatroomError(error, CREATE_NEW_MESSAGE))
    )
}

export const receiveNewMessage = (message) => ({
  type: RECEIVE_NEW_MESSAGE,
  message
})
