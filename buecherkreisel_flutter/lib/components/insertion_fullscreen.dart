import 'package:buecherkreisel_flutter/models/insertion.dart';
import 'package:flutter/material.dart';

class InsertionFullScreen extends StatelessWidget {
  Insertion insertion;
  InsertionFullScreen({
    super.key,
    required this.insertion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Image(image: AssetImage("lib/assets/6NyIq.jpg")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                insertion.headline,
                overflow: TextOverflow.clip,
              ),
              IconButton(
                onPressed: () => print("Not FaveIcon implmented"),
                icon: const Icon(Icons.favorite),
              )
            ],
          ),
          Row(
            children: [
              Text("${insertion.price}€"),
              const Text("Nur Abholung (hardcoded)"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(insertion.location),
              Text(insertion.category),
            ],
          ),
          const Divider(),
          Text(
            insertion.description,
            overflow: TextOverflow.clip,
          ),
          const Divider(),
          const Text("missing contact possibility"),
        ],
      ),
    );
  }
}
