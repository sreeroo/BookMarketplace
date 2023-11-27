import 'package:buecherkreisel_flutter/models/insertion.dart';
import 'package:buecherkreisel_flutter/components/insertion_fullscreen.dart';
import 'package:flutter/material.dart';

class InsertionPreview extends StatelessWidget {
  late Insertion insertion;

  InsertionPreview({super.key, required this.insertion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InsertionFullScreen(insertion: insertion),
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
                  insertion.category,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(insertion.location),
              ],
            ),
            const Image(image: AssetImage("lib/assets/6NyIq.jpg")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(insertion.headline,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("${insertion.price.toString()}€",
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
      ),
    );
  }
}

List<Insertion> sampleDataInsertion = [
  Insertion(
      id: "1",
      category: "Haus und Garten",
      description: "Gartenmöbel-Set, 5-teilig",
      price: 299.99,
      location: "Hannover",
      headline: "Hochwertiges Gartenmöbel-Set zu verkaufen",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "2",
      category: "Elektronik",
      description: "Apple MacBook Pro 13'', 512GB SSD, Space Gray",
      price: 1899.99,
      location: "Braunschweig",
      headline: "Neuwertiges MacBook Pro zum Verkauf",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "3",
      category: "Fahrzeuge",
      description: "Volkswagen Golf VII, Baujahr 2015, 50.000 km",
      price: 13999.99,
      location: "Göttingen",
      headline: "Zuverlässiger Gebrauchtwagen in gutem Zustand",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "4",
      category: "Kleidung",
      description: "Herren Winterjacke, Größe L, Schwarz",
      price: 79.99,
      location: "Oldenburg",
      headline: "Stylische Winterjacke für Herren zu verkaufen",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "5",
      category: "Haustiere",
      description: "Ragdoll-Kätzchen, 12 Wochen alt, weiblich",
      price: 499.99,
      location: "Lüneburg",
      headline: "Liebevolles Zuhause für süßes Ragdoll-Kätzchen gesucht",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "6",
      category: "Sport und Freizeit",
      description: "Mountainbike, 27,5 Zoll, schwarz/rot",
      price: 699.99,
      location: "Wolfenbüttel",
      headline: "Hochwertiges Mountainbike in gutem Zustand zu verkaufen",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "7",
      category: "Wohnung und Immobilien",
      description: "4-Zimmer-Wohnung, 90 qm, zentral gelegen",
      price: 899.99,
      location: "Celle",
      headline: "Geräumige Wohnung mit guter Anbindung zu vermieten",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "8",
      category: "Bücher",
      description: "Harry Potter und der Stein der Weisen, gebundene Ausgabe",
      price: 14.99,
      location: "Stade",
      headline: "Beliebtes Buch für Potterheads abzugeben",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "9",
      category: "Musikinstrumente",
      description: "E-Gitarre, Fender Stratocaster, schwarz",
      price: 699.99,
      location: "Emden",
      headline: "Professionelle E-Gitarre von Fender zu verkaufen",
      selfPickUp: true,
      createdBy: "123"),
  Insertion(
      id: "10",
      category: "Kunst und Design",
      description: "Moderne Gemälde-Serie, abstrakt, handgemalt",
      price: 499.99,
      location: "Wilhelmshaven",
      headline: "Kunstwerke für eine stilvolle Raumgestaltung",
      selfPickUp: true,
      createdBy: "123")
];
