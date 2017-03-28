import React from 'react';
import { Provider } from 'react-redux';
import { HashRouter as Router, Route, IndexRoute } from 'react-router-dom';
import { createHashHistory } from 'history';

import App from './app';

const Root = ({store}) => {
  return (
    <Provider store={store}>
      <Router history={createHashHistory()}>
        <div>
          <Route exact path="/" component={App} />
        </div>
      </Router>
    </Provider>
  );
}

export default Root;
