typedef user_id = String;

class User {
  user_id id;
  String username;
  String imageURL;
  User({required this.id, required this.imageURL, required this.username});

  // parse Item from JSON-data
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        imageURL: json['imageURL'],
        username: json['username'],
      );

  // map item to JSON-data
  Map<String, dynamic> toJson() => {
        "id": id,
        "imageURL": imageURL,
        "username": username,
      };
}
