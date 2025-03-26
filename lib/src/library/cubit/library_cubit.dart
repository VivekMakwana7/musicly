import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/src/library/library_page.dart';

part 'library_state.dart';

/// For handler [LibraryPage]'s state
class LibraryCubit extends Cubit<LibraryState> {
  /// Library Cubit Constructor
  LibraryCubit() : super(LibraryState());

  /// For add Playlist
  final playlistController = TextEditingController();

  /// Playlist Stream
  late final playlistStream = Injector.instance<AppDB>().songPlaylistStream();

  @override
  Future<void> close() {
    playlistController.dispose();
    return super.close();
  }
}
