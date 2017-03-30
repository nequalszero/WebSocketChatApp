import React from 'react';
import classNames from 'classnames';

class LoginForm extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    this.usernameInput.focus();
  }

  renderErrors = () => {
    if (this.props.errors.length > 0) {
      return (
        <div className="auth-form-errors">
          {this.props.errors}
        </div>
      );
    }
    return <br/>;
  }

  submitForm = () => {
    this.props.handleSubmit();
  }

  submitText = () => {
    return this.props.processing ? "Logging in..." : "Login";
  }

  render() {
    return (
      <form className="auth-form" onSubmit={ this.submitForm }>
        { this.renderErrors() }
        <label>Username</label>
        <input onChange={ (event) => this.props.handleInputChange("username", event.target.value) }
          ref={ (input) => {this.usernameInput = input;} }
          type="text"></input>

        <label>Password</label>
        <input onChange={ (event) => this.props.handleInputChange("password", event.target.value) }
          type="password"></input>
        <br/><br/>
        <div className="auth-buttons-container">
          <button type="submit" value="Submit">{this.submitText()}</button>
          <button className="cancel"
            onClick={ this.props.onRequestClose }>Cancel</button>
        </div>
      </form>
    );
  }
}

export default LoginForm;
