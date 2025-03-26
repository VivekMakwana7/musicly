import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';

part 'home_state.dart';

/// Home page's cubit
class HomeCubit extends Cubit<HomeState> {
  /// Default constructor
  HomeCubit() : super(HomeState());

  /// Stream for liked song update
  late final Stream<BoxEvent> likedSongStream = Injector.instance<AppDB>().likedSongStream();
}
