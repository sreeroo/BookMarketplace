import 'package:buecherkreisel_flutter/backend/datatypes.dart';
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
          Image(image: AssetImage("lib/assets/6NyIq.jpg")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                insertion.headline,
                overflow: TextOverflow.clip,
              ),
              IconButton(
                onPressed: () => print("Not FaveIcon implmented"),
                icon: Icon(Icons.favorite),
              )
            ],
          ),
          Row(
            children: [
              Text("${insertion.price}€"),
              Text("Nur Abholung (hardcoded)"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(insertion.location),
              Text(insertion.category),
            ],
          ),
          Divider(),
          Text(
            insertion.description,
            overflow: TextOverflow.clip,
          ),
          Divider(),
          Text("missing contact possibility"),
        ],
      ),
    );
  }
}
