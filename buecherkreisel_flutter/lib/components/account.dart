import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (b, state, w) => Column(
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
                backgroundImage: NetworkImage(state.user.imageURI),
              ),
              title: Text(state.user.username),
              trailing: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => state.logout(),
              ),
            ),
          ),
          Divider(),
          // Weitere Einstellungen können hier hinzugefügt werden
        ],
      ),
    );
  }
}
