import 'package:meta/meta.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/paginated/paginated_cubit.dart';
import 'package:musicly/core/rest_utils/api_request.dart';
import 'package:musicly/repos/music_repo.dart';
import 'package:musicly/src/artist/song/artist_song_page.dart';

part 'artist_song_state.dart';

/// For handle [ArtistSongPage]'s state
class ArtistSongCubit extends PaginatedCubit<ArtistSongState> {
  /// Artist Song Cubit constructor
  ArtistSongCubit({required this.artistId}) : super(const ArtistSongState());

  /// For get Artist Song  list
  final String artistId;

  final MusicRepo _searchRepo = Injector.instance<MusicRepo>();

  ///
  int _page = 0;

  @override
  int get page => _page;

  ///
  @override
  set page(int value) {
    _page = value;
  }

  @override
  ApiState get apiState => state.apiState;

  @override
  Future<void> getData() async {
    emit(
      state.copyWith(
        apiState: state.songs.isEmpty ? ApiState.loading : ApiState.loadingMore,
      ),
    );
    final param = {
      'page': page,
      'sortBy': 'popularity',
      // 'latest','alphabetical',
      'sortOrder': 'asc',
      // 'desc'
    };
    'artistId : $artistId'.logD;
    final res = await _searchRepo.getArtistSong(
      artistId,
      ApiRequest(params: param),
    );
    res.when(
      success: (data) {
        'data : ${data.songs?.map((e) => e.id).toList()}'.logD;
        hasMoreData = data.songs?.isNotEmpty ?? false;
        emit(
          state.copyWith(
            apiState: ApiState.success,
            songs: [...state.songs, ...?data.songs],
          ),
        );
      },
      error: (exception) {
        'Artist song API failed : $exception'.logE;
        exception.message.showErrorAlert();
        emit(state.copyWith(apiState: ApiState.error));
      },
    );
  }
}
