import * as APIUtil from '../util/session_api_util'

export const RECEIVE_CURRENT_USER = "RECEIVE_CURRENT_USER";
export const RECEIVE_SESSION_ERRORS = "RECEIVE_SESSION_ERRORS";
export const OPEN_LOGIN = "OPEN_LOGIN";
export const OPEN_SIGNUP = "OPEN_SIGNUP";
export const CLOSE_AUTH_MODAL = "CLOSE_AUTH_MODAL";

export const signup = (user) => dispatch => (
  APIUtil.signup(user)
    .then( (user) => dispatch(receiveCurrentUser(user)),
      (err) => dispatch(receiveErrors(err.responseJSON, "signup")) )
);

export const login = (user) => dispatch => (
  APIUtil.login(user)
    .then( (user) => dispatch(receiveCurrentUser(user)),
      (err) => dispatch(receiveErrors(err.responseJSON, "login")) )
);

export const logout = () => dispatch => (
  APIUtil.logout().then( (user) => dispatch(receiveCurrentUser(null)) )
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
