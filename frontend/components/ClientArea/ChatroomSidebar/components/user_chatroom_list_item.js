import React from 'react';
import classNames from 'classnames';

const UserChatroomListItem = (props) => {
  const className = () => {
    return classNames({
      "chatroom-list-item": true,
      current: props.isCurrentChatroom,
      selectable: !props.isCurrentChatroom
    })
  }

  return (
    <div className={className()} onClick={() => props.handleClick(props.id)}>
      <span># {props.name}</span>
    </div>
  )
}

export default UserChatroomListItem;
