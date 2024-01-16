import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIClient {
  // use IP 10.0.2.2 to access localhost from windows client
  //static const baseUrl = "http://127.0.0.1:8080/";

  // use IP 10.0.2.2 to access localhost from emulator!
  static const baseUrl = "http://10.0.2.2:8080/";

  var _client = http.Client();

  // set _client for testing
  set client(http.Client client) => _client = client;

  // GET
  Future<dynamic> fetchData(String endpoint,
      [Map<String, dynamic>? queryParams]) async {
    Uri uri = Uri.parse('$baseUrl$endpoint');

    if (queryParams != null) {
      uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    }

    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Connection': 'keep-alive',
      },
    );

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
  Future<http.StreamedResponse> postDataMultipart(
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

    final streamedResponse = await _client.send(response);

    if (streamedResponse.statusCode == 201) {
      return streamedResponse;
    } else {
      throw Exception('Failed to create data');
    }
  }

  // UPDATE
  Future<dynamic> updateData(String endpoint, dynamic data) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl$endpoint'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode < 300) {
      if(response.statusCode == 204) return; 
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to update data');
    }
  }

  // UPDATE using multipart/form-data (PATCH)
  Future<http.StreamedResponse> patchDataMultipart(
      String endpoint, dynamic data,
      [File? imageFile]) async {
    final response =
        await http.MultipartRequest('PATCH', Uri.parse('$baseUrl$endpoint'));

    response.headers.addAll(<String, String>{
      'Content-Type': 'multipart/form-data',
      'Connection': 'keep-alive',
    });

    response.fields.addAll(data);

    if (imageFile != null) {
      response.files.add(
        await http.MultipartFile.fromPath(
          'images',
          imageFile.path,
        ),
      );
    }

    final streamedResponse = await _client.send(response);

    if (streamedResponse.statusCode <= 300) {
      return streamedResponse;
    } else {
      throw Exception('Failed to update data');
    }
  }

  // DELETE
  Future<http.Response> deleteData(String endpoint) async {
    Uri uri = Uri.parse('$baseUrl$endpoint');

    final response = await _client.delete(uri);

    if (response.statusCode >= 300) {
      throw Exception('Failed to delete data');
    }
    return response;
  }

  /*

NOT USED AT THE MOMENT - MAYBE USEFUL LATER
  
  // Update using multipart/form-data (PUT)
  Future<http.StreamedResponse> updateDataMultipart(
      String endpoint, dynamic data,
      [File? imageFile]) async {
    final response =
        await http.MultipartRequest('PUT', Uri.parse('$baseUrl$endpoint'));

    response.headers.addAll(<String, String>{
      'Content-Type': 'multipart/form-data',
      'Connection': 'keep-alive',
    });

    response.fields.addAll(data);

    if (imageFile != null) {
      response.files.add(
        await http.MultipartFile.fromPath(
          'images',
          imageFile.path,
        ),
      );
    }

    final streamedResponse = await response.send();

    if (streamedResponse.statusCode <= 300) {
      return streamedResponse;
    } else {
      throw Exception('Failed to update data');
    }
  }
  */
}
