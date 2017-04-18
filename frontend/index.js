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

// root.html.erb file will initialize localStorage key currentUser to be "" if there is no current user.
// If there is a current user, the currentUser key will have an object with the form:
//  {username: String, id: Integer, chatrooms: Array}
// Similarly the otherChatrooms key will be "" if there is no currentUser, else it will be an array
const initializeStore = () => {
  if (window.localStorage.currentUser && JSON.parse(window.localStorage.currentUser)) {
    const { username, id, chatrooms } = JSON.parse(window.localStorage.currentUser);
    const currentUser = { username, id };
    const otherChatrooms = JSON.parse(window.localStorage.otherChatrooms);

    const preloadedState = {
      session: Object.assign({}, defaultState, { currentUser: currentUser }),
      // userChatrooms: chatrooms,
      // otherChatrooms
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
