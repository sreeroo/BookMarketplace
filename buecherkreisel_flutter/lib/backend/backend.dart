import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIClient {
  // use IP 10.0.2.2 to access localhost from windows client
  //static const baseUrl = "http://127.0.0.1:8080/";

  // use IP 10.0.2.2 to access localhost from emulator!
  static const baseUrl = "http://10.0.2.2:8080/";

  final _client = http.Client();

  // GET
  Future<dynamic> fetchData(String endpoint) async {
    final response =
        await _client.get(Uri.parse('$baseUrl$endpoint'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'keep-alive',
    });

    // check response from backend
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load data');
    }
  }

  // POST
  Future<dynamic> postData(String endpoint, dynamic data) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      body: json.encode(data),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode <= 300) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to create data');
    }
  }

  // POST using multipart/form-data
  Future<dynamic> postDataMultipart(
      String endpoint, dynamic data, File imageFile) async {
    final response =
        await http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));

    response.headers.addAll(<String, String>{
      'Content-Type': 'multipart/form-data',
      'Connection': 'keep-alive',
    });
    response.fields.addAll(data);
    response.files.add(
      await http.MultipartFile.fromPath(
        'images',
        imageFile.path,
      ),
    );

    try {
      final streamedResponse = await response.send();

      if (streamedResponse.statusCode == 200) {
        final response = await streamedResponse.stream.bytesToString();
        return response;
      } else {
        return null; // todo handle error according to your needs
      }
    } catch (e) {
      print('Error: $e');
      return null; // todo  handle error
    }
  }

  // UPDATE
  Future<dynamic> updateData(String endpoint, dynamic data) async {
    final response = await _client.put(
      Uri.parse('$baseUrl$endpoint'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to update data');
    }
  }

  // DELETE
  Future<void> deleteData(String endpoint) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete data');
    }
  }
}
