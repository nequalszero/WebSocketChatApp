import React from 'react';

import UserChatrooms from './components/user_chatrooms';

class Sidebar extends React.Component {
  render() {
    return (
      <div className="sidebar">
        <div className="status-and-group-placeholder">Status/Group Placeholder</div>
        <UserChatrooms chatrooms={this.props.userChatrooms}
          currentChatroom={this.props.currentChatroom}
          selectCurrentChatroom={(chatroomId) => this.props.selectCurrentChatroom(chatroomId)}/>
      </div>
    )
  }
}

export default Sidebar;
