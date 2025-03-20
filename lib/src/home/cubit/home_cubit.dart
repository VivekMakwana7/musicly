import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';

part 'home_state.dart';

/// Home page's cubit
class HomeCubit extends Cubit<HomeState> {
  /// Default constructor
  HomeCubit() : super(HomeState()) {
    recentPlayedStream = Injector.instance<AppDB>().recentPlayedSongStream();
  }

  /// Stream for recent Played Song Update
  late final Stream<BoxEvent> recentPlayedStream;
}
