import { connect } from 'react-redux';
import ClientArea from './client_area';

import { selectCurrentChatroom, receiveNewMessage } from '../../actions/chatroom_actions';

const mapStateToProps = (state) => {
  return {
    userChatrooms: state.chatrooms.userChatrooms,
    authenticated: state.session.currentUser
  };
}

const mapDispatchToProps = (dispatch) => ({
  selectCurrentChatroom: (chatroomId) => dispatch(selectCurrentChatroom(chatroomId)),
  receiveNewMessage: (message) => dispatch(receiveNewMessage(message))
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ClientArea);
