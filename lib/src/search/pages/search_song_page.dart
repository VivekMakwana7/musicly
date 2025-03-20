import 'package:flutter/material.dart';

/// Search Song Page
class SearchSongPage extends StatelessWidget {
  /// Search Song Page constructor
  const SearchSongPage({super.key, this.query});

  /// For search songs
  final String? query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Search songs')), body: Center(child: Text(query ?? '')));
  }
}
