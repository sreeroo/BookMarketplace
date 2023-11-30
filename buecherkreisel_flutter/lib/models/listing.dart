class Listing {
  int id;
  String title;
  double price;
  String category;
  bool offersDelivery;
  String description;
  bool isReserved;
  int createdBy;
  String location;

  Listing({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.offersDelivery,
    required this.description,
    required this.isReserved,
    required this.createdBy,
    required this.location,
  });

  // parse Item from JSON-data
  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        category: json["category"],
        offersDelivery: json["offersDelivery"],
        description: json["description"],
        isReserved: json["reserved"],
        createdBy: json["userID"],
        location: json["location"],
      );

  // map item to JSON-data
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "category": category,
        "offersDelivery": offersDelivery,
        "description": description,
        "reserved": isReserved,
        "userID": createdBy,
        "location": location,
      };
}
