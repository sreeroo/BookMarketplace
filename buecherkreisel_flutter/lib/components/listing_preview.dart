import 'dart:convert';

import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:buecherkreisel_flutter/components/listing_fullscreen.dart';
import 'package:flutter/material.dart';

class ListingPreview extends StatelessWidget {
  late Listing listing;

  ListingPreview({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListingFullScreen(listing: listing),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  listing.category,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(listing.location),
              ],
            ),
            Image(
                image: MemoryImage(
                    const Base64Decoder().convert(listing.imageBase64!))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(listing.title,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text("${listing.price.toString()}€",
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
      ),
    );
  }
}

List<Listing> sampleDataListing = [
  Listing(
      id: 1,
      category: "Haus und Garten",
      description: "Gartenmöbel-Set, 5-teilig",
      price: 299.99,
      location: "Hannover",
      title: "Hochwertiges Gartenmöbel-Set zu verkaufen",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 2,
      category: "Elektronik",
      description: "Apple MacBook Pro 13'', 512GB SSD, Space Gray",
      price: 1899.99,
      location: "Braunschweig",
      title: "Neuwertiges MacBook Pro zum Verkauf",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 3,
      category: "Fahrzeuge",
      description: "Volkswagen Golf VII, Baujahr 2015, 50.000 km",
      price: 13999.99,
      location: "Göttingen",
      title: "Zuverlässiger Gebrauchtwagen in gutem Zustand",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 4,
      category: "Kleidung",
      description: "Herren Winterjacke, Größe L, Schwarz",
      price: 79.99,
      location: "Oldenburg",
      title: "Stylische Winterjacke für Herren zu verkaufen",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 5,
      category: "Haustiere",
      description: "Ragdoll-Kätzchen, 12 Wochen alt, weiblich",
      price: 499.99,
      location: "Lüneburg",
      title: "Liebevolles Zuhause für süßes Ragdoll-Kätzchen gesucht",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 6,
      category: "Sport und Freizeit",
      description: "Mountainbike, 27,5 Zoll, schwarz/rot",
      price: 699.99,
      location: "Wolfenbüttel",
      title: "Hochwertiges Mountainbike in gutem Zustand zu verkaufen",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 7,
      category: "Wohnung und Immobilien",
      description: "4-Zimmer-Wohnung, 90 qm, zentral gelegen",
      price: 899.99,
      location: "Celle",
      title: "Geräumige Wohnung mit guter Anbindung zu vermieten",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 8,
      category: "Bücher",
      description: "Harry Potter und der Stein der Weisen, gebundene Ausgabe",
      price: 14.99,
      location: "Stade",
      title: "Beliebtes Buch für Potterheads abzugeben",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 9,
      category: "Musikinstrumente",
      description: "E-Gitarre, Fender Stratocaster, schwarz",
      price: 699.99,
      location: "Emden",
      title: "Professionelle E-Gitarre von Fender zu verkaufen",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
  Listing(
      id: 10,
      category: "Kunst und Design",
      description: "Moderne Gemälde-Serie, abstrakt, handgemalt",
      price: 499.99,
      location: "Wilhelmshaven",
      title: "Kunstwerke für eine stilvolle Raumgestaltung",
      offersDelivery: true,
      createdBy: 123,
      isReserved: false),
];
