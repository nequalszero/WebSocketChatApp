import {  RECEIVE_NEW_MESSAGE,
          RECEIVE_UPDATED_MESSAGE,
          RECEIVE_CHATROOM_MESSAGES,
          RECEIVE_NON_USER_CHATROOMS,
          RECEIVE_USER_CHATROOMS,
          RECEIVE_USER_CHATROOM,
          RECEIVE_CHATROOM_ERROR,
          CLEAR_CHATROOMS,
          SELECT_CURRENT_CHATROOM
        } from '../actions/chatroom_actions';

// Error types
import {  JOIN_CHATROOM,
          CREATE_CHATROOM,
          CREATE_NEW_MESSAGE
        } from '../actions/chatroom_actions';

import { removeChatroomIfExists,
         findSelectedChatroom
        } from '../lib/chatrooms_helper';
import merge from 'lodash/merge';

const _defaultState = Object.freeze({
  userChatrooms: [],
  nonUserChatrooms: [],
  currentChatroom: null,
  errors: []
})

const ChatroomsReducer = (oldState = _defaultState, action) => {
  let newState = merge({}, oldState);
  newState.errors = []

  switch(action.type) {
    case RECEIVE_USER_CHATROOM:
      const newChatroom = action.chatroom;
      newState.nonUserChatrooms = removeChatroomIfExists(newChatroom, newState.nonUserChatrooms);
      newState.userChatrooms = [newChatroom, ...newState.userChatrooms];
      return newState;

    case RECEIVE_CHATROOM_ERROR:
      newState.errors = action.error;
      return newState;

    case RECEIVE_USER_CHATROOMS:
      newState.userChatrooms = action.chatrooms;
      return newState;

    case RECEIVE_NON_USER_CHATROOMS:
      newState.nonUserChatrooms = action.chatrooms;
      return newState;

    case CLEAR_CHATROOMS:
      newState.nonUserChatrooms = [];
      newState.userChatrooms = [];
      newState.currentChatroom = null;
      return newState;

    case SELECT_CURRENT_CHATROOM:
      newState.currentChatroom = findSelectedChatroom(action.chatroomId, newState.userChatrooms);
      return newState;

    case RECEIVE_NEW_MESSAGE:
      const targetChatroom = findSelectedChatroom(action.message.chatroom_id, newState.userChatrooms);
      targetChatroom.messages.push(action.message);
      if (newState.currentChatroom && newState.currentChatroom.id === targetChatroom.id) {
        newState.currentChatroom.messages.push(action.message);
      }
      return newState;

    default:
      return oldState;
  }
}

export default ChatroomsReducer
