import 'package:flutter/material.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/sheet/music_sheet_widget.dart';

/// For display song play more widget
class SongPlayMoreWidget extends StatelessWidget {
  /// Song Play More Widget Constructor
  const SongPlayMoreWidget({super.key, this.song, this.songId, this.isDecorated = false});

  /// Factory for song
  factory SongPlayMoreWidget.song({required DbSongModel song, bool isDecorated = false}) {
    return SongPlayMoreWidget(song: song, isDecorated: isDecorated);
  }

  /// Factory for id
  factory SongPlayMoreWidget.id({required String songId}) {
    return SongPlayMoreWidget(songId: songId);
  }

  ///
  final DbSongModel? song;

  ///
  final String? songId;

  /// Is song decorated
  final bool isDecorated;

  @override
  Widget build(BuildContext context) {
    Widget icon = Assets.icons.icMore.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn));

    if (isDecorated) {
      icon = DecoratedBox(
        decoration: recentPlayedItemDecoration,
        child: Padding(padding: const EdgeInsets.all(8), child: icon),
      );
    }

    return IconButton(
      icon: icon,
      onPressed: () async {
        if (songId != null) {
          final song = await DatabaseHandler.getSongById(songId!);
          if (context.mounted) MusicSheetWidget.show(context, song: song!);
        }

        if (song != null) {
          if (context.mounted) MusicSheetWidget.show(context, song: song!);
        }
      },
      style: IconButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
    );
  }
}
