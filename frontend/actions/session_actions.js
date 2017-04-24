import * as APIUtil from '../util/session_api_util'

import { receiveUserChatrooms,
         receiveNonUserChatrooms,
         clearChatrooms
       } from './chatroom_actions';

import { createHashHistory } from 'history';

export const RECEIVE_CURRENT_USER = "RECEIVE_CURRENT_USER";
export const RECEIVE_SESSION_ERRORS = "RECEIVE_SESSION_ERRORS";
export const OPEN_LOGIN = "OPEN_LOGIN";
export const OPEN_SIGNUP = "OPEN_SIGNUP";
export const CLOSE_AUTH_MODAL = "CLOSE_AUTH_MODAL";

const hashHistory = createHashHistory();

// Actions to be dispatched upon successful login.
//   Expects a user object with id, username, chatrooms, nonUserChatrooms.
const createNewSession = ({id, username, chatrooms, nonUserChatrooms}, dispatch) => {
  dispatch(receiveCurrentUser({id, username}));
  dispatch(receiveUserChatrooms(chatrooms));
  dispatch(receiveNonUserChatrooms(nonUserChatrooms));
  hashHistory.push("/chatrooms");
}

// Signs up new user, dispatches actions to populate currentUser, userChatrooms,
//   and nonUserChatrooms sections of the state.
export const signup = (user) => dispatch => (
  APIUtil.signup(user)
    .then(
      (user) => createNewSession(user, dispatch),
      (err) => dispatch(receiveErrors(err.responseJSON, "signup"))
    )
);

// Logins in user, dispatches actions to populate currentUser, userChatrooms,
//   and nonUserChatrooms sections of the state.
export const login = (user) => dispatch => (
  APIUtil.login(user)
    .then(
      (user) => createNewSession(user, dispatch),
      (err) => dispatch(receiveErrors(err.responseJSON, "login"))
    )
);

// Dispatches actions to be evoked upon successful logout.
const destroySession = (dispatch) => {
  dispatch(receiveCurrentUser(null));
  dispatch(clearChatrooms());
}

//
export const logout = () => dispatch => (
  APIUtil.logout().then( () => destroySession(dispatch) )
);

export const receiveCurrentUser = currentUser => ({
  type: RECEIVE_CURRENT_USER,
  currentUser
});

export const receiveErrors = (errors, formType) => ({
  type: RECEIVE_SESSION_ERRORS,
  formType,
  errors
});

export const openLogin = () => ({
  type: OPEN_LOGIN
})

export const openSignup = () => ({
  type: OPEN_SIGNUP
})

export const closeAuthModal = () => ({
  type: CLOSE_AUTH_MODAL
})
