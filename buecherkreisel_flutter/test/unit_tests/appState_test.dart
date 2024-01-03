import 'package:flutter_test/flutter_test.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/models/user.dart';

void main() {
  group('AppState', () {
    AppState appState = AppState();

    test('setUser updates the user and notifies listeners', () {
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

    test('setToken updates the token and notifies listeners', () {
      String testToken = "testToken";

      bool notified = false;
      appState.addListener(() {
        notified = true;
      });

      appState.setToken(testToken);

      expect(appState.user.token, equals(testToken));
      expect(notified, isTrue);
    });

    test('logout resets the user and notifies listeners', () {
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
