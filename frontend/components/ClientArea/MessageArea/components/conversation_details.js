import React from 'react';

const ConversationDetails = (props) => {
  const memberCount =  Object.keys(props.users).length;

  return (
    <div className="conversation-details">
      <div className="name-and-number-of-members">
        <p className="conversation-name">#{props.name}</p>
        <p className="number-of-members">{memberCount} members</p>
      </div>
    </div>
  )
}

export default ConversationDetails;
