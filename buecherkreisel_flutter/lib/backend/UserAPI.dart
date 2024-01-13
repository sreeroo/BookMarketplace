import 'dart:async';
import 'dart:convert';

import "package:buecherkreisel_flutter/models/user.dart";
import 'package:http/http.dart' as http;
import '../models/listing.dart';
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
    Map<String, dynamic> userData = await _restAPI
        .fetchData('users/${response['id']}', {"token": {response['token']}});
    response.addAll(userData); 
    return User.fromJson(response);
  }

  // READ user as public
  Future<User> getUserAsPublic(String id) async {
    final response = await _restAPI.fetchData('users/$id/public');
    return User.fromJson(response);
  }

  // LOGIN a user
  Future<User> loginUser(String username, password) async {
    Map<String, dynamic> response = await _restAPI
        .postData('login', {"username": username, "password": password});
    Map<String, dynamic> userData = await _restAPI
        .fetchData('users/${response['id']}', {"token": {response['token']}});
    response.addAll(userData); 
    return User.fromJson(response);
  }

  // UPDATE THE PROFILE PICTURE OF A USER
  FutureOr<Map<String, dynamic>> updateProfilePicture(
      User user, String imageURL) async {
    final response = await _restAPI.updateData('users/edit_pic/${user.id}', {
      "token": user.token,
      "new_picture": imageURL,
    });
    return response;
  }

  Future<Set<int>> getLikedListings(User user) async {
    final responseData = await _restAPI.fetchData('users/${user.id}', {
      "token": user.token
    }) as Map<String, dynamic>;

    List<dynamic> dynamicList = json.decode(responseData["liked_listings"]);

    return dynamicList.cast<int>().toSet();

  }

  Future<dynamic> updateLikedListings(User user) async{
    final response = await _restAPI.updateData('users/edit_likes/${user.id}', {
      "liked_listings": jsonEncode(user.likedListings.toString()), 
      "token": user.token
    }); 
    return response; 
  }

/*

NOT USED AT THE MOMENT - MAYBE USEFUL LATER

   // UPDATE username of an existing User on the backend
  Future<User> updateUsername(User user) async {
    final response =
        await _restAPI.updateData('users/edit_alias/${user.id}', user.toJson());
    return User.fromJson(response);
  }

  // UPDATE an existing User on the backend
  Future<User> updateUser(User user) async {
    final response =
        await _restAPI.updateData('users/${user.id}', user.toJson());
    return User.fromJson(response);
  }


  // DELETE an existing User on the backend
  Future<void> deleteUser(User user) async {
    await _restAPI.deleteData('users/delete/${user.id}');
  }
*/
}
