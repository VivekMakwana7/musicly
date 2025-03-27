import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/src/liked/liked_page.dart';

part 'like_state.dart';

/// For handler [LikedPage]'s state
class LikeCubit extends Cubit<LikeState> {
  /// Liked Page Cubit constructor
  LikeCubit() : super(LikeState());

  /// Stream for liked song update
  late final likedSongStream = Injector.instance<AppDB>().likedSongStream();
}
