import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:musicly/src/library/library_page.dart';

part 'library_state.dart';

/// For handler [LibraryPage]'s state
class LibraryCubit extends Cubit<LibraryState> {
  /// Library Cubit Constructor
  LibraryCubit() : super(LibraryState());

  /// For add Playlist
  final playlistController = TextEditingController();

  @override
  Future<void> close() {
    playlistController.dispose();
    return super.close();
  }
}
