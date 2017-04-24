import React from 'react';
import { Provider } from 'react-redux';
import { HashRouter as Router, Route, IndexRoute } from 'react-router-dom';
import { createHashHistory } from 'history';

import App from './app';
import ClientAreaContainer from './ClientArea/client_area_container';

const Root = ({store}) => {
  return (
    <Provider store={store}>
      <Router history={createHashHistory()}>
        <div>
          <App>
            <Route path="/chatrooms/:chatroomId?"
              component={ClientAreaContainer}/>
          </App>
        </div>
      </Router>
    </Provider>
  );
}

export default Root;
