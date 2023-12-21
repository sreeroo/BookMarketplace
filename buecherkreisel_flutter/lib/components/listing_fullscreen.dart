import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/backend/utils.dart';
import 'package:buecherkreisel_flutter/models/listing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingFullScreen extends StatelessWidget {
  final Listing listing;

  ListingFullScreen({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.memory(
                imageFromBase64String(listing.imageBase64!)!.bytes,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  listing.title,
                  overflow: TextOverflow.clip,
                ),
                IconButton(
                  onPressed: () => print("Not FaveIcon implemented"),
                  icon: const Icon(Icons.favorite),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${listing.price}€',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ort: ${listing.location}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Kategorie: ${listing.category}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              'Beschreibung:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              listing.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              'Kontakt:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              listing.contact,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Versand möglich: ',
                  style: TextStyle(fontSize: 16),
                ),
                Icon(
                  listing.offersDelivery
                      ? Icons.check_circle_sharp
                      : Icons.cancel_sharp,
                  color: listing.offersDelivery ? Colors.green : Colors.red,
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              'Posted by:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Consumer<AppState>(
              builder: (context, appState, child) {
                final user = appState.user;
                return Text(
                  user.username,
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
