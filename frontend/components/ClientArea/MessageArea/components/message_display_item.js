import React from 'react';

const MessageDisplayItem = (props) => {

  return (
    <div className="message-display-item">
      <div className="username-and-time-container">
        <span className="username">{props.username}</span>
        <span className="timestamp">{props.timestamp.toLocaleString()}</span>
      </div>
      <div className="body">
        {props.body}
      </div>
    </div>
  )
}

export default MessageDisplayItem;
