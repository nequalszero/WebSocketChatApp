import React from 'react';
import { connect } from 'react-redux';
import * as Actions from '../../actions/session_actions';
import Auth from './auth';

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
  errors: state.session.errors,
  activePanel: state.session.activePanel
})

const mapDispatchToProps = (dispatch) => ({
  loginUser: (user) => dispatch(Actions.login(user)),
  signupUser: (user) => dispatch(Actions.signup(user)),
  openLogin: () => dispatch(Actions.openLogin()),
  openSignup: () => dispatch(Actions.openSignup()),
  closeAuthModal: () => dispatch(Actions.closeAuthModal())
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Auth);
