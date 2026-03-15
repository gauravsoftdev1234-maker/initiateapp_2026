class ChatMessage {
  final int id;
  final int senderId;
  final String message;
  final String messageType;
  final String msgDate;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.message,
    required this.messageType,
    required this.msgDate,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['Id'],
      senderId: json['SenderId'],
      message: json['Message'],
      messageType: json['MessageType'],
      msgDate: json['MsgDate'],
    );
  }
}