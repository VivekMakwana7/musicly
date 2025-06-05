import 'package:bloc/bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';

part 'download_state.dart';

/// For handle download page' state
class DownloadCubit extends Cubit<DownloadState> {
  /// Download Page Constructor
  DownloadCubit() : super(const DownloadState());

  ///
  final Stream<BoxEvent> downloadStream =
      AppDB.downloadManager.downloadedSongStream();
}
