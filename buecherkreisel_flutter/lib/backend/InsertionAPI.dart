import 'package:http/http.dart' as http;
import "package:buecherkreisel_flutter/models/insertion.dart";
import 'backend.dart';

class InsertionAPI {
  final restAPI = APIClient();

  // get list of all insertions from the backend
  Future<List<Insertion>> getAllInsertions(http.Client client) async {
    final response = await restAPI.fetchData(client, 'insertions');
    return List<Insertion>.from(response.map((e) => Insertion.fromJson(e)));
  }

  // save a new Insertion on the backend
  Future<Insertion> createInsertion(
      http.Client client, Insertion insertion) async {
    final response =
        await restAPI.postData(client, 'insertions', insertion.toJson());
    return Insertion.fromJson(response);
  }

  // update an existing Insertion on the backend
  Future<Insertion> updateInsertion(
      http.Client client, Insertion insertion) async {
    final response = await restAPI.updateData(
        client, 'insertions/${insertion.id}', insertion.toJson());
    return Insertion.fromJson(response);
  }

  // delete an existing Insertion on the backend

  Future<void> deleteInsertion(http.Client client, Insertion insertion) async {
    await restAPI.deleteData(client, 'insertions/${insertion.id}');
  }

  // get a specific Insertion from the backend

  Future<Insertion> getInsertionById(http.Client client, String id) async {
    final response = await restAPI.fetchData(client, 'insertions/$id');
    return Insertion.fromJson(response);
  }
}
