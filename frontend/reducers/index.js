import { combineReducers } from 'redux';
import SessionReducer from './session_reducer';
import { reducer as FormReducer } from 'redux-form';

const RootReducer = combineReducers({
  session: SessionReducer,
  form: FormReducer
});

export default RootReducer;
