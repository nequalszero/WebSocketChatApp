import { connect } from 'react-redux';
import Sidebar from './sidebar';

import { selectCurrentChatroom } from '../../../actions/chatroom_actions';

const mapStateToProps = (state) => {
  return {
    currentUser: state.session.currentUser,
    userChatrooms: state.chatrooms.userChatrooms,
    nonUserChatrooms: state.chatrooms.nonUserChatrooms,
    currentChatroom: state.chatrooms.currentChatroom
  }
}

const mapDispatchToProps = (dispatch) => ({
  selectCurrentChatroom: (chatroomId) => dispatch(selectCurrentChatroom(chatroomId))
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Sidebar)
