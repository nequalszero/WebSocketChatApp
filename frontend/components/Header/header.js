import React from 'react';

class Header extends React.Component {
  state = {
    processingLogout: false
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.processingLogout && this.props.currentUser && !nextProps.currentUser) {
      this.setState({processingLogout: false});
    }
  }

  handleLogout = () => {
    if (!this.state.processingLogout) {
      this.props.logout();
      this.setState({processingLogout: true});
    }
  }

  logoutText() {
    return this.state.processingLogout ? "Logging out..." : "Logout"
  }

  authLinks() {
    return (
      <nav className="header-nav">
        <li onClick={this.props.openSignup}>Signup</li>
        <li onClick={this.props.openLogin}>Login</li>
      </nav>
    );
  }

  logoutLink() {
    return (
      <nav className="header-nav">
        <li onClick={this.handleLogout}>{this.logoutText()}</li>
      </nav>
    );
  }

  render() {
    return (
      <div className="header-container">
        { this.props.currentUser ? this.logoutLink() : this.authLinks() }
      </div>
    );
  }
}

export default Header;
