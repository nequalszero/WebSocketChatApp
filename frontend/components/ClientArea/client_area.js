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

  componentDidMount() {
    // Pusher event listener for new messages created by other channel members
    var pusher = new Pusher('62ce9c55c56e3b1a7fad', {
      encrypted: true
    });

    this.props.userChatrooms.forEach((chatroom) => {
      let channel = pusher.subscribe(`chatroom_${chatroom.id}`);

      channel.bind('message_created', (data) => {
        this.props.receiveNewMessage(data.message);
      })
    })
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
