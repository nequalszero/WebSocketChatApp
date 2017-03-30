//React
import React from 'react';
import ReactDOM from 'react-dom';
//Components
import Root from './components/root';
import configureStore from './store/store';
import Modal from 'react-modal';

//Helpers
import { defaultState } from './lib/session_helper';
import merge from 'lodash/merge';

const initializeStore = () => {
  if (window.localStorage.currentUser && JSON.parse(window.localStorage.currentUser)) {
    let currentUser = JSON.parse(window.localStorage.currentUser);

    const preloadedState = {
      session: Object.assign({}, defaultState, { currentUser: currentUser })
    };

    return configureStore(preloadedState);
  } else {
    return configureStore();
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const store = initializeStore();

  window.store = store;
  console.log("Warning: store currently bound to window, see frontend/index.js");

  Modal.setAppElement(document.body);
  const rootEl = document.getElementById('root');
  ReactDOM.render(<Root store={store} />, rootEl);
});
