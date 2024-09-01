import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MarvelApiService {
  final String _publicKey = dotenv.env['MARVEL_PUBLIC_KEY']!;
  final String _privateKey = dotenv.env['MARVEL_PRIVATE_KEY']!;
  final String _baseUrl = 'https://gateway.marvel.com:443/v1/public';
  final GetStorage _storage = GetStorage();

  String _generateHash(int timestamp) {
    return md5
        .convert(utf8.encode('$timestamp$_privateKey$_publicKey'))
        .toString();
  }

  Future<void> fetchAndStoreCharacters({String? searchText}) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String hash = _generateHash(timestamp);

    // Base URL with required parameters
    String url =
        '$_baseUrl/characters?ts=$timestamp&apikey=$_publicKey&hash=$hash&limit=40';

    if (kDebugMode) {
      print("search text $searchText");
    }
    if (searchText != null && searchText.isNotEmpty) {
      url += '&nameStartsWith=${Uri.encodeComponent(searchText)}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final characters = data['data']['results'];
      if (kDebugMode) {
        print("chars $characters");
      }
      _storage.write('characters', json.encode(characters));
    } else {
      throw Exception('Failed to load characters');
    }
  }

  List<dynamic>? getCharacters() {
    final jsonString = _storage.read('characters');
    return jsonString != null ? json.decode(jsonString) : null;
  }
}
