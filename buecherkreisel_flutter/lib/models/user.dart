import 'dart:convert';

typedef user_id = String;

class User {
  user_id id;
  String username;
  String profilePicture;
  String token;
  String totalListings;
  List<int> likedListings; 
  User(
      {required this.id,
      required this.profilePicture,
      required this.username,
      required this.token,
      this.totalListings = "", 
      List<int>? likedListings,
  }) : likedListings = likedListings ?? List<int>.empty(growable: true);

  // parse Item from JSON-data
  factory User.fromJson(Map<String, dynamic> jsonString) => User(
        id: jsonString['id'],
        profilePicture: jsonString['profile_picture'] ?? "",
        username: jsonString['username'],
        token: jsonString['token'],
        totalListings: jsonString['total_listings'] ?? "",
        likedListings: jsonString['liked_listings']==null ? List.empty(growable: true) : 
                                                            json.decode(jsonString['liked_listings']).cast<int>(),
      );

  // map item to JSON-data
  /**
   Map<String, dynamic> toJson() => {
        "id": id,
        "profile_picture": profilePicture,
        "username": username,
        "token": token,
        "total_listings": totalListings,
      };
  **/
}
