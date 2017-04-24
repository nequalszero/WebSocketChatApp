import { connect } from 'react-redux';
import ClientArea from './client_area';

import { selectCurrentChatroom } from '../../actions/chatroom_actions';

const mapStateToProps = (state) => {
  return {
    authenticated: state.session.currentUser
  };
}

const mapDispatchToProps = (dispatch) => ({
  selectCurrentChatroom: (chatroomId) => dispatch(selectCurrentChatroom(chatroomId))
})

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ClientArea);
