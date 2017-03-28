//React
import React from 'react';
import ReactDOM from 'react-dom';
//Components
import Root from './components/root';
import configureStore from './store/store';
import Modal from 'react-modal';

import {login, signup, logout} from './actions/session_actions';

window.login = login;
window.signup = signup;
window.logout = logout;

const initializeStore = () => {
  if (window.localStorage.currentUser) {
    let currentUser = JSON.parse(window.localStorage.currentUser);
    const preloadedState = { session: { currentUser: currentUser }};
    return configureStore(preloadedState);
  }
  return configureStore();
}

document.addEventListener('DOMContentLoaded', () => {
  const store = initializeStore();

  window.store = store;
  console.log("Warning: store currently bound to window, see frontend/index.js");

  Modal.setAppElement(document.body);
  const rootEl = document.getElementById('root');
  ReactDOM.render(<Root store={store} />, rootEl);
});
