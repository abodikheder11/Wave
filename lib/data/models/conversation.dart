class Conversation{
  final String name;
  final String lastMessage;
  final String imageURL;
  final String timeStamp;
  final String lastSeen;
  late int unreadCount;

  Conversation({required this.name ,required this.lastMessage ,required this.imageURL ,required this.timeStamp ,required this.lastSeen , this.unreadCount = 0});
}