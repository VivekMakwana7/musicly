import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/app_db.dart';

part 'home_state.dart';

/// Home page's cubit
class HomeCubit extends Cubit<HomeState> {
  /// Default constructor
  HomeCubit() : super(HomeState()) {
    _songListener();
  }

  final _likeManager = AppDB.likedManager;
  final _homeManager = AppDB.homeManager;

  /// Stream for liked song update
  late final Stream<BoxEvent> likedSongStream = _likeManager.likedSongStream();

  /// Stream for Recent Played Song Update
  late final Stream<BoxEvent> recentPlayedStream = _homeManager.recentPlayedSongStream();

  /// It indicates the either Home Screen is empty or has data
  final isHomeEmpty = ValueNotifier(true);

  void _songListener() {
    isHomeEmpty.value = _likeManager.likedSongs.isEmpty && _homeManager.recentPlayedSongs.isEmpty;
    likedSongStream.listen((event) {
      isHomeEmpty.value = _likeManager.likedSongs.isEmpty && _homeManager.recentPlayedSongs.isEmpty;
    });
    recentPlayedStream.listen((event) {
      isHomeEmpty.value = _likeManager.likedSongs.isEmpty && _homeManager.recentPlayedSongs.isEmpty;
    });
  }
}
