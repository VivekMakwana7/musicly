import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/search/model/song/global_song_model.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Song Search Widget
class SongSearchWidget extends StatelessWidget {
  /// Song Search Widget Constructor
  const SongSearchWidget({super.key, this.globalSongs, this.query, this.dbSongs});

  /// Constructor for displaying songs from the local database.
  factory SongSearchWidget.fromDatabase(List<DbSongModel> songs) {
    return SongSearchWidget(dbSongs: songs);
  }

  /// Constructor for displaying songs from a global source.
  factory SongSearchWidget.api({required List<GlobalSongModel> songs, String? query}) {
    return SongSearchWidget(globalSongs: songs, query: query);
  }

  /// List of songs from a global source.
  final List<GlobalSongModel>? globalSongs;

  /// The search query used to find these songs (if applicable).
  final String? query;

  /// List of songs from the local database.
  final List<DbSongModel>? dbSongs;

  @override
  Widget build(BuildContext context) {
    final songs = globalSongs ?? dbSongs ?? [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Songs', style: context.textTheme.titleMedium),
            if (songs.length >= minSongsForViewAll)
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.searchSongPage, extra: {'query': query}),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                child: Text('View All', style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD))),
              ),
          ],
        ),
        if (globalSongs != null)
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final song = globalSongs![index];
                return SongItemWidget(
                  description: song.description ?? '',
                  songImageURL: song.image?.last.url ?? '',
                  title: song.title ?? '',
                  onTap: () {
                    Injector.instance<AudioCubit>().setNetworkSource(
                      type: SourceType.searchSong,
                      query: query ?? '',
                      songId: song.id,
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemCount: globalSongs!.length,
            ),
          ),
        if (dbSongs != null)
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final song = dbSongs![index];
                return SongItemWidget(
                  description: song.label ?? '',
                  songImageURL: song.image?.last.url ?? '',
                  title: song.name ?? '',
                  onTap: () {
                    if (song.downloadUrl?.last.url != null) {
                      Injector.instance<AudioCubit>().setLocalSource(song: song, source: dbSongs!);
                    } else {
                      'Audio url not found'.showErrorAlert();
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemCount: dbSongs!.take(minDbSongCountForDisplay).length,
            ),
          ),
      ],
    );
  }
}
