import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/src/liked/liked_page.dart';

part 'like_state.dart';

/// For handler [LikedPage]'s state
class LikeCubit extends Cubit<LikeState> {
  /// Liked Page Cubit constructor
  LikeCubit() : super(LikeState()) {
    checkIsLikedEmpty();
  }
  final _likedManager = AppDB.likedManager;

  /// Stream for liked song update
  late final likedSongStream = _likedManager.likedSongStream();

  /// Stream for Liked Album Update
  late final likedAlbumStream = _likedManager.likedAlbumStream();

  /// Stream for Liked Playlist Update
  late final likedPlaylistStream = _likedManager.likedPlaylistStream();

  /// For check if liked page is empty
  final isLikedEmpty = ValueNotifier(true);

  /// Listener for check all available liked stream and decide weather is liked empty or not
  void checkIsLikedEmpty() {
    isLikedEmpty.value = AppDB.likedManager.isLikedEmpty;

    AppDB.likedManager.likedSongStream().listen((event) {
      isLikedEmpty.value = AppDB.likedManager.isLikedEmpty;
    });
    AppDB.likedManager.likedAlbumStream().listen((event) {
      isLikedEmpty.value = AppDB.likedManager.isLikedEmpty;
    });
    AppDB.likedManager.likedPlaylistStream().listen((event) {
      isLikedEmpty.value = AppDB.likedManager.isLikedEmpty;
    });
  }

  @override
  Future<void> close() {
    isLikedEmpty.dispose();
    return super.close();
  }
}
