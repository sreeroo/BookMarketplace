import 'dart:convert';

import "package:buecherkreisel_flutter/models/user.dart";
import 'package:http/http.dart' as http;
import 'backend.dart';

class UserAPI {
  final _restAPI = APIClient();

  //set _restAPI client for testing
  void setClient(http.Client client) {
    _restAPI.client = client;
  }

  // CREATE a new User on the backend
  Future<User> createUser(String username, password) async {
    Map<String, dynamic> response = await _restAPI
        .postData('users/create', {"username": username, "password": password});
    response.addAll({"username": username});
    return User.fromJson(response);
  }

  // READ user as public
  Future<User> getUserAsPublic(String id) async {
    final response = await _restAPI.fetchData('users/$id/public');
    return User.fromJson(response);
  }

  // UPDATE an existing User on the backend
  Future<User> updateUser(User user) async {
    final response =
        await _restAPI.updateData('users/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // UPDATE username of an existing User on the backend

  Future<User> updateUsername(User user) async {
    final response =
        await _restAPI.updateData('users/edit_alias/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // UPDATE imageURL of an existing User on the backend

  Future<User> updateImageURL(User user) async {
    final response =
        await _restAPI.updateData('users/edit_pic/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // DELETE an existing User on the backend
  Future<void> deleteUser(User user) async {
    await _restAPI.deleteData('users/delete/${user.id}');
  }

  // LOGIN a user
  Future<User> loginUser(String username, password) async {
    Map<String, dynamic> response = await _restAPI
        .postData('login', {"username": username, "password": password});
    response.addAll({"username": username});
    return User.fromJson(response);
  }
}
