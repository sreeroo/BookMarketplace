typedef user_id = String;

class User {
  user_id id;
  String username;
  String password;
  String imageURI;
  String token;
  User(
      {required this.id,
      required this.imageURI,
      required this.username,
      required this.password,
      required this.token});

  // parse Item from JSON-data
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        imageURI: json['imageURL'],
        username: json['username'],
        password: json['password'],
        token: json['token'],
      );

  // map item to JSON-data
  Map<String, dynamic> toJson() => {
        "id": id,
        "imageURL": imageURI,
        "username": username,
        "token": token,
      };
}
