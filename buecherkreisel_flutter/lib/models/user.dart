import 'dart:ffi';

typedef user_id = String;

class User {
  user_id id;
  String username;
  String imageURI;
  User({required this.id, required this.imageURI, required this.username});

  // parse Item from JSON-data
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        imageURI: json['imageURL'],
        username: json['username'],
      );

  // map item to JSON-data
  Map<String, dynamic> toJson() => {
        "id": id,
        "imageURL": imageURI,
        "username": username,
      };
}
