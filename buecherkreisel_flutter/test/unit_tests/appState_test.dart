import 'package:flutter_test/flutter_test.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/models/user.dart';

void main() {
  group('AppState', () {
    AppState appState = AppState();

    test(
        'Test: setUser aktualisiert den Benutzer und benachrichtigt die Listener',
        () {
      User testUser = User(
          id: "1",
          profilePicture: "test",
          username: "testUser",
          token: "testToken");

      bool notified = false;
      appState.addListener(() {
        notified = true;
      });

      appState.setUser(testUser);

      expect(appState.user, equals(testUser));
      expect(notified, isTrue);
    });

    test(
        'Test: setToken aktualisiert den Token und benachrichtigt die Listener',
        () {
      String testToken = "testToken";

      bool notified = false;
      appState.addListener(() {
        notified = true;
      });

      appState.setToken(testToken);

      expect(appState.user.token, equals(testToken));
      expect(notified, isTrue);
    });

    test(
        'Test: Logout aktualisiert den Benutzer und benachrichtigt die Listener',
        () {
      User testUser = User(
          id: "1",
          profilePicture: "test",
          username: "testUser",
          token: "testToken");
      appState.setUser(testUser);

      bool notified = false;
      appState.addListener(() {
        notified = true;
      });

      appState.logout();

      expect(appState.user.id, equals(""));
      expect(appState.user.profilePicture, equals(""));
      expect(appState.user.username, equals(""));
      expect(appState.user.token, equals(""));

      expect(notified, isTrue);
    });
  });
}
