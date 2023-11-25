import 'user.dart';

class Insertion {
  String id;
  String headline;
  String description;
  double price;
  String location;
  String category;
  bool favorized;
  bool selfPickUp;
  user_id createdBy;
  Insertion(
      {required this.id,
      required this.category,
      required this.description,
      required this.price,
      required this.location,
      required this.headline,
      required this.selfPickUp,
      required this.createdBy,
      this.favorized = false});

  // parse Item from JSON-data
  factory Insertion.fromJson(Map<String, dynamic> json) => Insertion(
        id: json["id"],
        headline: json["headline"],
        description: json["description"],
        price: json["price"],
        location: json["location"],
        category: json["category"],
        favorized: json["favorized"],
        selfPickUp: json["selfPickUp"],
        createdBy: json["createdBy"],
      );

  // map item to JSON-data
  Map<String, dynamic> toJson() => {
        "id": id,
        "headline": headline,
        "description": description,
        "price": price,
        "location": location,
        "category": category,
        "favorized": favorized,
        "selfPickUp": selfPickUp,
        "createdBy": createdBy,
      };
}
