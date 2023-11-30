import 'package:http/http.dart' as http;
import "package:buecherkreisel_flutter/models/user.dart";
import 'backend.dart';

class UserAPI {
  final restAPI = APIClient();

  // CREATE a new User on the backend
  Future<User> createUser(User user) async {
    final response = await restAPI.postData('users/create', user.toJson());
    return User.fromJson(response);
  }

  // READ a specific User from the backend
  Future<User> getUserById(String id) async {
    final response = await restAPI.fetchData('users/$id');
    return User.fromJson(response);
  }

  // READ user as public
  Future<User> getUserAsPublic(String id) async {
    final response = await restAPI.fetchData('users/$id/public');
    return User.fromJson(response);
  }

  // UPDATE an existing User on the backend
  Future<User> updateUser(User user) async {
    final response =
        await restAPI.updateData('users/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // UPDATE username of an existing User on the backend

  Future<User> updateUsername(User user) async {
    final response =
        await restAPI.updateData('users/edit_alias/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // UPDATE imageURL of an existing User on the backend

  Future<User> updateImageURL(User user) async {
    final response =
        await restAPI.updateData('users/edit_pic/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // DELETE an existing User on the backend
  Future<void> deleteUser(User user) async {
    await restAPI.deleteData('users/delete/${user.id}');
  }
}
