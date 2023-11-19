import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:flutter/material.dart';

class InserationPreview extends StatelessWidget {
  late Inseration inseration;

  InserationPreview({super.key, required this.inseration});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(inseration.category),
              Text(inseration.location),
            ],
          ),
          const Image(image: AssetImage("lib/assets/6NyIq.jpg")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(inseration.headline,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${inseration.price.toString()}€",
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );
  }
}

List<Inseration> sampleDataInseration = [
  Inseration(
      category: "Haus und Garten",
      description: "Gartenmöbel-Set, 5-teilig",
      price: 299.99,
      location: "Hannover",
      headline: "Hochwertiges Gartenmöbel-Set zu verkaufen"),
  Inseration(
      category: "Elektronik",
      description: "Apple MacBook Pro 13'', 512GB SSD, Space Gray",
      price: 1899.99,
      location: "Braunschweig",
      headline: "Neuwertiges MacBook Pro zum Verkauf"),
  Inseration(
      category: "Fahrzeuge",
      description: "Volkswagen Golf VII, Baujahr 2015, 50.000 km",
      price: 13999.99,
      location: "Göttingen",
      headline: "Zuverlässiger Gebrauchtwagen in gutem Zustand"),
  Inseration(
      category: "Kleidung",
      description: "Herren Winterjacke, Größe L, Schwarz",
      price: 79.99,
      location: "Oldenburg",
      headline: "Stylische Winterjacke für Herren zu verkaufen"),
  Inseration(
      category: "Haustiere",
      description: "Ragdoll-Kätzchen, 12 Wochen alt, weiblich",
      price: 499.99,
      location: "Lüneburg",
      headline: "Liebevolles Zuhause für süßes Ragdoll-Kätzchen gesucht"),
  Inseration(
      category: "Sport und Freizeit",
      description: "Mountainbike, 27,5 Zoll, schwarz/rot",
      price: 699.99,
      location: "Wolfenbüttel",
      headline: "Hochwertiges Mountainbike in gutem Zustand zu verkaufen"),
  Inseration(
      category: "Wohnung und Immobilien",
      description: "4-Zimmer-Wohnung, 90 qm, zentral gelegen",
      price: 899.99,
      location: "Celle",
      headline: "Geräumige Wohnung mit guter Anbindung zu vermieten"),
  Inseration(
      category: "Bücher",
      description: "Harry Potter und der Stein der Weisen, gebundene Ausgabe",
      price: 14.99,
      location: "Stade",
      headline: "Beliebtes Buch für Potterheads abzugeben"),
  Inseration(
      category: "Musikinstrumente",
      description: "E-Gitarre, Fender Stratocaster, schwarz",
      price: 699.99,
      location: "Emden",
      headline: "Professionelle E-Gitarre von Fender zu verkaufen"),
  Inseration(
      category: "Kunst und Design",
      description: "Moderne Gemälde-Serie, abstrakt, handgemalt",
      price: 499.99,
      location: "Wilhelmshaven",
      headline: "Kunstwerke für eine stilvolle Raumgestaltung")
];
