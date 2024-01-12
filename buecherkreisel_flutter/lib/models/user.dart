typedef user_id = String;

class User {
  user_id id;
  String username;
  String profilePicture;
  String token;
  String totalListings;
  User(
      {required this.id,
      required this.profilePicture,
      required this.username,
      required this.token,
      this.totalListings = ""});

  // parse Item from JSON-data
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        profilePicture: json['profile_picture'] ?? "",
        username: json['username'],
        token: json['token'],
        totalListings: json['total_listings'] ?? "",
      );

  // map item to JSON-data
  /**Map<String, dynamic> toJson() => {
        "id": id,
        "profile_picture": profilePicture,
        "username": username,
        "token": token,
        "total_listings": totalListings,
      };**/
}
