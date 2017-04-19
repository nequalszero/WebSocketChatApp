export const createChatroomMember = (chatroomId) => {
  return $.ajax({
    method: 'POST',
    url: `/api/chatrooms/${chatroomId}/chatroom_members`
  });
};

export const deleteChatroomMember = ({chatroomMemberId}) => {
  return $.ajax({
    method: 'DELETE',
    url: `/api/chatroom_members/${chatroomMemberId}`
  });
};

export const createChatroom = (name) => {
  return $.ajax({
    method: 'POST',
    url: `api/chatrooms`,
    data: {chatroom: {name}}
  })
}

export const createMessage = ({chatroomId, body}) => {
  return $.ajax({
    method: 'POST',
    url: `api/chatrooms/${chatroomId}/messages`,
    data: {message: {body}}
  })
}

export const updateMessage = ({messageId, body}) => {
  return $.ajax({
    method: 'PATCH',
    url: `api/messages/${messageId}`,
    data: {message: {body}}
  })
}
