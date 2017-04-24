import React from 'react';
import MessageDisplayItem from './message_display_item';

const MessageDisplayArea = (props) => {
  return (
    <div className="message-display-area-container">
      <div className="message-display-area">
        {props.messages.map((message) => (
          <MessageDisplayItem body={message.body}
            username={props.users[message.user_id]}
            timestamp={new Date(message.created_at)}
            key={message.id}
            id={message.id}/>
        ))}
      </div>
    </div>
  );
}

export default MessageDisplayArea;
