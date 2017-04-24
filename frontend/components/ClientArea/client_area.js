import React from 'react';
import SidebarContainer from './ChatroomSidebar/sidebar_container';
import MessageAreaContainer from './MessageArea/message_area_container';

class ClientArea extends React.Component {
  componentWillMount() {
    const chatroomId = parseInt(this.props.match.params.chatroomId);
    if (!isNaN(chatroomId)) {
      this.props.selectCurrentChatroom(chatroomId);
    }
  }

  authenticatedContent() {
    return (
      <div className="client-area">
        <SidebarContainer />
        <MessageAreaContainer />
      </div>
    );
  }

  unauthenticatedContent() {
    return <div></div>;
  }

  render() {
    return (
      this.props.authenticated ? this.authenticatedContent() : this.unauthenticatedContent()
    );
  }
}

export default ClientArea;
