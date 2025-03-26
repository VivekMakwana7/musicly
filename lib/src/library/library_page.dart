import 'package:flutter/material.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';

/// Library Page
class LibraryPage extends StatelessWidget {
  /// Library Page Constructor
  const LibraryPage({super.key, this.song});

  /// For add Song in Playlist
  final DbSongModel? song;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Library : ${song?.id} | ${song?.name}'));
  }
}
