import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'character_details.dart';

class MarvelCharacterPage extends StatelessWidget {
  final List<dynamic> characters;

  const MarvelCharacterPage({super.key, required this.characters});

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const Center(child: Text('No characters found.'));
    }

    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.5,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: characters.map((character) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CharacterDetailPage(character: character),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Flex(
                        direction: Axis.vertical,
                        children: [
                          Expanded(
                            child: ClipRect(
                              child: Image.network(
                                '${character['thumbnail']['path']}.${character['thumbnail']['extension']}',
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              character['name'],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
