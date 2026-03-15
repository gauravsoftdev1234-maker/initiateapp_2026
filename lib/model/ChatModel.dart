class ChatResponse {
  final int statusCode;
  final String message;
  final List<ChatParticipant> response;

  ChatResponse({required this.statusCode, required this.message, required this.response});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      response: (json['Response'] as List)
          .map((i) => ChatParticipant.fromJson(i))
          .toList(),
    );
  }
}

class ChatParticipant {
  final int chatId;
  final String otherUserName;
  final String otherUserProfileImage;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  ChatParticipant({
    required this.chatId,
    required this.otherUserName,
    required this.otherUserProfileImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      chatId: json['ChatId'],
      otherUserName: json['OtherUserName'],
      otherUserProfileImage: json['OtherUserProfileImage'],
      lastMessage: json['LastMessage'],
      lastMessageTime: json['LastMessageTime'],
      unreadCount: json['UnreadCount'],
    );
  }
}