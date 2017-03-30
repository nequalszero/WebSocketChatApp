import { RECEIVE_CURRENT_USER,
         RECEIVE_SESSION_ERRORS,
         OPEN_LOGIN,
         OPEN_SIGNUP,
         CLOSE_AUTH_MODAL
       } from '../actions/session_actions';
import { defaultState } from '../lib/session_helper';
import merge from 'lodash/merge';

const _nullUser = Object.freeze(defaultState);

const resetPanelsAndErrors = (newState) => {
  newState.activePanel = {
    login: false,
    signup: false
  };
  newState.errors = {
    login: [],
    signup: []
  };
}

// Merge with _nullUser instead of oldState because of issues with errors
//  array, if merging with oldState, an oldState errors array of 2 items
//  merging with an action.errors array of 1 item will merge to give a new
//  errors array of 2 items, with the first old item replaced with the first
//  action.errors item, instead of replacing the entire array.
const SessionReducer = (oldState = _nullUser, action) => {
  let newState = merge({}, oldState);

  switch(action.type) {
    // Handles both login and logout of users; action.currentUser = null for logout.
    case RECEIVE_CURRENT_USER:
      resetPanelsAndErrors(newState);
      let currentUser = action.currentUser;
      newState.currentUser = currentUser;
      window.localStorage.setItem("currentUser", JSON.stringify(currentUser));
      return newState;

    case RECEIVE_SESSION_ERRORS:
      newState.errors[`${action.formType}`] = action.errors;
      newState.currentUser = null;
      window.localStorage.setItem("currentUser", JSON.stringify(""));
      return newState;

    case OPEN_LOGIN:
      newState.activePanel = {
        login: true,
        signup: false
      };
      return newState;

    case OPEN_SIGNUP:
      newState.activePanel = {
        login: false,
        signup: true
      };
      return newState;

    case CLOSE_AUTH_MODAL:
      resetPanelsAndErrors(newState);
      return newState;

    default:
      return oldState;
  }
};

export default SessionReducer;
