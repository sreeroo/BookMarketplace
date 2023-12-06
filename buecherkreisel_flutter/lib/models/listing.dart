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
  String? imageBase64;

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
    this.imageBase64,
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
        imageBase64: json["images"][0],
      );

  // map item to JSON-data
  Map<String, String> toJson() => {
        "title": title,
        "price": "$price",
        "category": category,
        "offersDelivery": "$offersDelivery",
        "description": description,
        "isReserved": "$isReserved",
        "user_id": "$createdBy",
        "location": location,
      };
}
