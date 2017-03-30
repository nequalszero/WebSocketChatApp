import React from 'react';
import { Link } from 'react-router';
import HeaderContainer from './Header/header_container';
import AuthContainer from './Auth/auth_container';

class App extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="app">
        <HeaderContainer />
        <AuthContainer />
        {this.props.children}
      </div>
    );
  }
}

export default App;
