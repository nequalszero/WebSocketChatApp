import React from 'react';
import AuthModal from './auth_modal';

class Auth extends React.Component {
  modalIsOpen() {
    const { login, signup } = this.props.activePanel;
    return login || signup;
  }

  activeTab() {
    const { login, signup } = this.props.activePanel;
    return login ? "login" : "signup";
  }

  closeModal = (processing) => {
    if (!processing) {
      this.props.closeAuthModal();
    }
  }

  render() {
    return (
      <AuthModal modalIsOpen={ this.modalIsOpen() }
        onRequestClose={ this.closeModal }
        openSignup={ () => this.props.openSignup() }
        openLogin={ () => this.props.openLogin() }
        loginUser={ (user) => this.props.loginUser(user) }
        signupUser={ (user) => this.props.signupUser(user) }
        formType={ this.activeTab() }
        errors={ this.props.errors }/>
    )
  }
}

Auth.propTypes = {
  currentUser: React.PropTypes.object,
  errors: React.PropTypes.object.isRequired,
  activePanel: React.PropTypes.object.isRequired
}

export default Auth;
