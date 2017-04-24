import React from 'react';

const MessageWritingArea = (props) => {
  return (
    <div className="new-message-area-container">
      <div className="new-message-area">
        <div className="add-feature">
          <span>+</span>
        </div>
        <form className="message-input-container" onSubmit={() => props.handleFormSubmit()}>
          <input type="text" ref={(input) => props.refCallback(input)}></input>
        </form>
      </div>
    </div>
  );
}

export default MessageWritingArea;
