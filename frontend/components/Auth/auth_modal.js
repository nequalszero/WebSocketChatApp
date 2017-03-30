import React from 'react';
import Modal from 'react-modal';
import LoginForm from './login_form';
import SignupForm from './signup_form';
import classNames from 'classnames';

const customStyle = {
  content: {
    top                   : '50%',
    left                  : '50%',
    right                 : 'auto',
    bottom                : 'auto',
    marginRight           : '-50%',
    transform             : 'translate(-50%, -50%)',
    padding               : '0px 0px',
    font                  : '16px sans-serif',
    borderRadius          : '0px',
    boxShadow             : '0px 10px 25px rgba(0, 0, 0, 0.5)'
  }
};

class AuthModal extends React.Component {
  state = {
    loginForm: {
      username: "",
      password: ""
    },
    signupForm: {
      username: "",
      password: ""
    },
    processing: false
  };

  componentWillReceiveProps(nextProps) {
    if (this.state.processing) this.setState({processing: false});
  }

  handleTabChange = (tabName) => {
    if (tabName !== this.props.formType) {
      if (tabName === "login") this.props.openLogin();
      else this.props.openSignup();
    }
  }

  formClass = (tabName) => {
    return classNames({
      'active-tab': tabName === this.props.formType,
      'inactive-tab': tabName !== this.props.formType
    });
  }

  validateInputParameters = (type, field, value) => {
    if ( !this.state.hasOwnProperty(type) ) return false;
    if ( !this.state[`${type}`].hasOwnProperty(field) ) return false;
    return true;
  }

  handleInputChange(type) {
    return ((field, value) => {
      if (this.validateInputParameters(type, field, value)) {
        const newState = this.state;
        newState[`${type}`][`${field}`] = value;
        this.setState(newState);
      } else {
        console.log(`Error in AuthModal#handleInputChange - Trying to update state[${type}][${field}] but the field does not exist.`);
      }
    });
  }

  handleSubmit = (type) => {
    this.setState({processing: true})
    if (type === "login") {
      this.props.loginUser({user: this.state.loginForm});
    } else {
      this.props.signupUser({user: this.state.signupForm});
    }
  }

  loadForm = () => {
    if (this.props.formType === "login") {
      return (
        <LoginForm errors={ this.props.errors.login }
          onRequestClose={ () => this.props.onRequestClose(this.state.processing) }
          handleSubmit={ () => this.handleSubmit("login") }
          handleInputChange={ this.handleInputChange("loginForm") }
          values={ this.state.loginForm }
          processing={ this.state.processing }/>
      );
    }
    return (
      <SignupForm errors={ this.props.errors.signup }
        onRequestClose={ () => this.props.onRequestClose(this.state.processing) }
        handleSubmit={ () => this.handleSubmit("signup") }
        handleInputChange={ this.handleInputChange("signupForm") }
        values={ this.state.signupForm }
        processing={ this.state.processing }/>
    );
  }

  render() {
    return (
      <Modal isOpen={ this.props.modalIsOpen }
        onRequestClose={ () => this.props.onRequestClose(this.state.processing) }
        contentLabel="Modal"
        style={customStyle}>
        <div className="auth-container">
          <nav className="form-type">
            <li className={ this.formClass('signup') }
              onClick={() => this.handleTabChange('signup')}> Signup </li>
            <li className={ this.formClass('login') }
              onClick={() => this.handleTabChange('login')}> Login </li>
          </nav>
          { this.loadForm() }
        </div>
      </Modal>
    );
  }
}

export default AuthModal;
