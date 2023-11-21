import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:flutter/material.dart';

class InserationFullScreen extends StatelessWidget {
  Inseration inseration;
  InserationFullScreen({
    super.key,
    required this.inseration,
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
                inseration.headline,
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
              Text("${inseration.price}€"),
              Text("Nur Abholung (hardcoded)"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(inseration.location),
              Text(inseration.category),
            ],
          ),
          Divider(),
          Text(
            inseration.description,
            overflow: TextOverflow.clip,
          ),
          Divider(),
          Text("missing contact possibility"),
        ],
      ),
    );
  }
}
