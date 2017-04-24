import { connect } from 'react-redux';
import MessageArea from './message_area';

import { createMessage } from '../../../actions/chatroom_actions';

const mapStateToProps = (state) => ({
  chatroom: state.chatrooms.currentChatroom
})

const mapDispatchToProps = (dispatch) => ({
  createMessage: (data) => dispatch(createMessage(data))
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(MessageArea);
