import React from 'react';
import ConversationDetails from './components/conversation_details';
import MessageDisplayArea from './components/message_display_area';
import MessageWritingArea from './components/message_writing_area';

class MessageArea extends React.Component {
  handleFormSubmit = () => {
    if (this.inputField.value.length > 0) {
      this.props.createMessage({
        body: this.inputField.value,
        chatroomId: this.props.chatroom.id
      });
      this.inputField.value = "";
    }
  }

  render() {
    const chatroom = this.props.chatroom;

    return (
      <div className="message-area">
        <ConversationDetails users={chatroom.users}
          name={chatroom.name}/>
        <MessageDisplayArea users={chatroom.users}
          messages={chatroom.messages}/>
        <MessageWritingArea handleFormSubmit={() => this.handleFormSubmit()}
          refCallback={(input) => {this.inputField = input}}/>
      </div>
    );
  }
}

export default MessageArea;
