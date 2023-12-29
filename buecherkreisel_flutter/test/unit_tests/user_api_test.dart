import 'package:buecherkreisel_flutter/backend/UserAPI.dart';
import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final userAPI = UserAPI();
  final mockClient = MockClient();
  userAPI.setClient(mockClient);

  group('UserAPI', () {
    test('createUser sends a POST request', () async {
      // Arrange
      when(mockClient.post(any,
              body: anyNamed('body'),
              headers: anyNamed('headers'),
              encoding: anyNamed('encoding')))
          .thenAnswer(
              (_) async => http.Response('{"id":"1","token":"test"}', 201));

      // Act
      final response = await userAPI.createUser('user1', 'password');

      // Assert
      expect(response.id, "1");
      expect(response.token, "test");
    });

    test('create User throws an exception', () async {
      // Arrange
      when(mockClient.post(any,
              body: anyNamed('body'),
              headers: anyNamed('headers'),
              encoding: anyNamed('encoding')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      final response = userAPI.createUser('user1', 'password');

      // Assert
      expect(response, throwsException);
    });

    test('getUserAsPublic sends a GET request', () async {
      // Arrange
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
              '{"id":"1", "username":"user1", "profile_picture":"test", "total_listings":"0", "token":"test"}',
              200));

      // Act
      final response = await userAPI.getUserAsPublic('1');

      // Assert
      expect(response.id, "1");
    });
  });
}
