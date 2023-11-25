import 'package:http/http.dart' as http;
import "package:buecherkreisel_flutter/models/user.dart";
import 'backend.dart';

class UserAPI {
  final restAPI = APIClient();

  // CREATE a new User on the backend
  Future<User> createUser(http.Client client, User user) async {
    final response =
        await restAPI.postData(client, 'users/create', user.toJson());
    return User.fromJson(response);
  }

  // READ a specific User from the backend
  Future<User> getUserById(http.Client client, String id) async {
    final response = await restAPI.fetchData(client, 'users/$id');
    return User.fromJson(response);
  }

  // READ user as public
  Future<User> getUserAsPublic(http.Client client, String id) async {
    final response = await restAPI.fetchData(client, 'users/$id/public');
    return User.fromJson(response);
  }

  // UPDATE an existing User on the backend
  Future<User> updateUser(http.Client client, User user) async {
    final response =
        await restAPI.updateData(client, 'users/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // UPDATE username of an existing User on the backend

  Future<User> updateUsername(http.Client client, User user) async {
    final response = await restAPI.updateData(
        client, 'users/edit_alias/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // UPDATE imageURL of an existing User on the backend

  Future<User> updateImageURL(http.Client client, User user) async {
    final response = await restAPI.updateData(
        client, 'users/edit_pic/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // DELETE an existing User on the backend
  Future<void> deleteUser(http.Client client, User user) async {
    await restAPI.deleteData(client, 'users/delete/${user.id}');
  }
}
