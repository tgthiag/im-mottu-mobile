import 'package:flutter/material.dart';

import '../service/marvel_api.dart';
import 'marvel_character.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final MarvelApiService marvelApiService = MarvelApiService();
  List<dynamic> _characters = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialCharacters();
  }

  Future<void> _loadInitialCharacters() async {
    setState(() {
      _isLoading = true;
    });

    await marvelApiService.fetchAndStoreCharacters();
    setState(() {
      _characters = marvelApiService.getCharacters() ?? [];
      _isLoading = false;
    });
  }

  Future<void> searchCharacters(String searchText) async {
    setState(() {
      _isLoading = true;
    });

    await marvelApiService.fetchAndStoreCharacters(
        searchText: searchText.trim());
    setState(() {
      _characters = marvelApiService.getCharacters() ?? [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MARVEL',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 52),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a character...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (text) {
                searchCharacters(text);
              },
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: MarvelCharacterPage(characters: _characters),
                ),
        ],
      ),
    );
  }
}
