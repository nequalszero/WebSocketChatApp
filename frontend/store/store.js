import { createStore, compose, applyMiddleware } from 'redux';

// ReduxPromise middleware is not useful for resolving promises in a conditional
//   way => reduxThunk more useful
// import ReduxPromise from 'redux-promise';
import ReduxThunk from 'redux-thunk';
import RootReducer from '../reducers';

// Redux's compose method is used for using multiple function transformations to
//   enhance a store: in this case, Redux's applyMiddleware along with the code
//   to enable Redux DevTools.
export default function configureStore(initialState) {
  const store = createStore(
    RootReducer,
    initialState,
    compose(
      applyMiddleware(ReduxThunk),
      window.devToolsExtension ? window.devToolsExtension() : f => f
    )
  );

  if (module.hot) {
    // Enable Webpack hot module replacement for reducers.
    module.hot.accept('../reducers', () => {
      const nextRootReducer = require('../reducers').default;
      store.replaceReducer(nextRootReducer);
    });
  }

  return store;
}
