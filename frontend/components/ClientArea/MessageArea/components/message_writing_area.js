import React from 'react';

const MessageWritingArea = (props) => {
  return (
    <div className="new-message-area-container">
      <div className="new-message-area">
        <div className="add-feature">
          <span>+</span>
        </div>
        <div className="message-input-container">
          <input type="text"></input>
        </div>
      </div>
    </div>
  );
}

export default MessageWritingArea;
