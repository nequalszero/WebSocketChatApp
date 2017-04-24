import React from 'react';
import UserChatroomListItem from './user_chatroom_list_item';

const UserChatrooms = (props) => {
  const isCurrentChatroom = (chatroom) => {
    if (!props.currentChatroom) return false;
    return chatroom.id === props.currentChatroom.id;
  }

  const switchChatroom = (chatroomId) => {
    if (props.currentChatroom.id !== chatroomId) {
      props.selectCurrentChatroom(chatroomId);
    }
  }

  return(
    <div className="user-chatrooms">
      <p className="chatrooms-header">
        CHATROOMS ({props.chatrooms.length})
      </p>
      { props.chatrooms.map((chatroom) => (
        <UserChatroomListItem key={chatroom.id}
          isCurrentChatroom={isCurrentChatroom(chatroom)}
          handleClick={(chatroomId) => switchChatroom(chatroomId)}
          {...chatroom} />
      ))}
    </div>
  )
}

export default UserChatrooms;
