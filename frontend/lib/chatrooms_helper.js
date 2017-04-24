export const findChatroomIndex = (target, chatrooms) => {
  for (let idx = 0; idx < chatrooms.length; idx++) {
    if (chatrooms[idx].id === target.id) return idx;
  }
  return null;
}

export const removeChatroomIfExists = (target, chatrooms) => {
  const targetIdx = findChatroomIndex(target, chatrooms);

  if (targetIdx !== null) {
    return [
      ...chatrooms.slice(0, targetIdx),
      ...chatrooms.slice(targetIdx + 1)
    ];
  }
  return chatrooms;
}

export const findSelectedChatroom = (chatroomId, chatrooms) => {
  if (typeof chatroomId !== "number") return null;
  const targetIdx = findChatroomIndex({id: chatroomId}, chatrooms);

  if (targetIdx !== null) return chatrooms[targetIdx];
  return null;
}
