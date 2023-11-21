class Insertion {
  String headline;
  String description;
  double price;
  String location;
  String category;
  bool favorized;
  bool selfPickUp;
  user_id createdBy;
  Insertion(
      {required this.category,
      required this.description,
      required this.price,
      required this.location,
      required this.headline,
      required this.selfPickUp,
      required this.createdBy,
      this.favorized = false});
}

class Chat {
  user_id person;
  List<Message> messages;
  String imageUri;
  Chat({required this.person, required this.messages, required this.imageUri});
}

typedef user_id = String;

class Message {
  DateTime send;
  String message;
  user_id sendBy;
  Message(
      {required this.send,
      required this.message,
      required,
      required this.sendBy});
}

class User {
  user_id id;
  String imageURI;
  User({required this.id, required this.imageURI});
}
