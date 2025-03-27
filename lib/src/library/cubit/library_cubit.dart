import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/song_playlist/db_song_playlist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/src/library/library_page.dart';

part 'library_state.dart';

/// For handler [LibraryPage]'s state
class LibraryCubit extends Cubit<LibraryState> {
  /// Library Cubit Constructor
  LibraryCubit() : super(LibraryState());

  /// For add Playlist
  final playlistController = TextEditingController();

  final _appDb = Injector.instance<AppDB>();

  /// Playlist Stream
  late final playlistStream = _appDb.songPlaylistStream();

  @override
  Future<void> close() {
    playlistController.dispose();
    return super.close();
  }

  /// For handle New Playlist add
  void onNewTap() {
    if (playlistController.text.trim().isNotEmpty) {
      final list = Injector.instance<AppDB>().songPlaylist.toList();
      final model = DbSongPlaylistModel(
        name: playlistController.text.trim(),
        id: '${playlistController.text.trim()[0]}${DateTime.now().millisecondsSinceEpoch}',
        image: 'https://static.saavncdn.com/_i/share-image-2.png',
        songs: [],
      );
      list.add(model);
      Injector.instance<AppDB>().songPlaylist = list;
    } else {
      'Playlist name can not be empty'.showErrorAlert();
    }
  }

  /// For remove Playlist from list
  void onPlaylistRemoveTap(int index) {
    final list = Injector.instance<AppDB>().songPlaylist.toList()..removeAt(index);
    Injector.instance<AppDB>().songPlaylist = list;
  }
}
