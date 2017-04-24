import { combineReducers } from 'redux';
import SessionReducer from './session_reducer';
import ChatroomsReducer from './chatrooms_reducer';
import { reducer as FormReducer } from 'redux-form';

const RootReducer = combineReducers({
  session: SessionReducer,
  chatrooms: ChatroomsReducer,
  form: FormReducer
});

export default RootReducer;
