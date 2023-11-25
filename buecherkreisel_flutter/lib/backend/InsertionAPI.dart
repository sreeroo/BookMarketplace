import 'package:http/http.dart' as http;
import "package:buecherkreisel_flutter/models/insertion.dart";
import 'backend.dart';

class InsertionAPI {
  final restAPI = APIClient();

  // CREATE a new Insertion on the backend
  Future<Insertion> createInsertion(
      http.Client client, Insertion insertion) async {
    final response =
        await restAPI.postData(client, 'insertions', insertion.toJson());
    return Insertion.fromJson(response);
  }

  // READ list of all insertions from the backend
  Future<List<Insertion>> getAllInsertions(http.Client client) async {
    final response = await restAPI.fetchData(client, 'insertions');
    return List<Insertion>.from(response.map((e) => Insertion.fromJson(e)));
  }

  // READ a specific Insertion from the backend

  Future<Insertion> getInsertionById(http.Client client, String id) async {
    final response = await restAPI.fetchData(client, 'insertions/$id');
    return Insertion.fromJson(response);
  }

  // UPDATE an existing Insertion on the backend
  Future<Insertion> updateInsertion(
      http.Client client, Insertion insertion) async {
    final response = await restAPI.updateData(
        client, 'insertions/${insertion.id}', insertion.toJson());
    return Insertion.fromJson(response);
  }

  // DELETE an existing Insertion on the backend

  Future<void> deleteInsertion(http.Client client, Insertion insertion) async {
    await restAPI.deleteData(client, 'insertions/${insertion.id}');
  }
}
