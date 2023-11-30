import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://www.example.com/user-profile-image.jpg'),
                ),
                title: Text('Vorname Nachname'),
                subtitle: Text('+49 123 456 789'),
                trailing: Icon(Icons.edit),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Einstellungen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Benachrichtigungen'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Hier kannst du zu den Benachrichtigungseinstellungen navigieren
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.security),
                title: Text('Datenschutz'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Hier kannst du zu den Datenschutzeinstellungen navigieren
                },
              ),
            ),
            // Weitere Einstellungen können hier hinzugefügt werden
          ],
        ),
      ),
    );
  }
}
