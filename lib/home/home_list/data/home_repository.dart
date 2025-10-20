import 'dart:convert';

import '../models/home_list.dart';

import 'package:http/http.dart' as http;

abstract interface class HomeRepository {
  Future<HomeList> fetchItems(int page);
}

class HomeRepositoryImpl implements HomeRepository {
  late final http.Client httpClient;

  HomeRepositoryImpl(this.httpClient);

  Future<HomeList> fetchItems(int page) async {
    Uri url = Uri.parse('https://api.artic.edu/api/v1/artworks');

    try {
      final response = await httpClient.get(url);

      if (response.statusCode == 200) {
        // Request successful, process the response body
        print('Response body: ${response.body}');

        final Map<String, dynamic> decodedObject = jsonDecode(response.body);
        final HomeList object = HomeList.fromJson(decodedObject);

        return object;
      } else {
        // Request failed
        throw Exception("Error");
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error during network request: $e');

      throw Exception("Error");
    }
  }
}
