class Inseration {
  String headline;
  String description;
  double price;
  String location;
  String category;
  bool favorized;
  Inseration(
      {required this.category,
      required this.description,
      required this.price,
      required this.location,
      required this.headline,
      this.favorized = false});
}

class Chat {
  String person;
  List<Message> messages;
  String imageUri;
  Chat({required this.person, required this.messages, required this.imageUri});
}

class Message {
  DateTime send;
  String message;
  String send_by;
  Message(
      {required this.send,
      required this.message,
      required,
      required this.send_by});
}
