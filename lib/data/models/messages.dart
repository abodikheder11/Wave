
enum MessageStatus{sent , received , read}
class Message {
  String text;
  bool isCurrentUser;
  String timestamp;
  final bool isImage;
  String? reaction;
  MessageStatus status;

  Message(this.text, this.isCurrentUser , this.timestamp , {this.isImage = false , this.reaction , this.status = MessageStatus.sent });


  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCurrentUser': isCurrentUser,
      'timestamp': timestamp,
      'status': status.toString(),
      'reaction': reaction,
      'isImage': isImage,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['text'],
      json['isCurrentUser'],
      json['timestamp'],
      status: MessageStatus.values.firstWhere((e) => e.toString() == json['status']),
      reaction: json['reaction'],
      isImage: json['isImage'] ?? false,
    );
  }
}


