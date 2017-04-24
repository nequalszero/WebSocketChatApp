import React from 'react';
import ConversationDetails from './components/conversation_details';
import MessageDisplayArea from './components/message_display_area';
import MessageWritingArea from './components/message_writing_area';

class MessageArea extends React.Component {
  render() {
    const chatroom = this.props.chatroom;

    return (
      <div className="message-area">
        <ConversationDetails users={chatroom.users}
          name={chatroom.name}/>
        <MessageDisplayArea users={chatroom.users}
          messages={chatroom.messages}/>
        <MessageWritingArea createMessage={(data) => this.props.createMessage(data)}/>
      </div>
    );
  }
}

export default MessageArea;
