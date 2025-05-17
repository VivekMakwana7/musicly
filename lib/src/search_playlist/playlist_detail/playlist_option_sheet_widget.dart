import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/db/models/song_playlist/db_song_playlist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/sheet/music_sheet_widget.dart';
import 'package:musicly/src/music/sheet/song_quality_sheet_widget.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// For display Playlist sheet widget
class PlaylistOptionSheetWidget extends StatelessWidget {
  /// Playlist Sheet Widget constructor
  const PlaylistOptionSheetWidget({required this.playlist, super.key});

  /// for display Playlist details
  final DbPlaylistModel playlist;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: DecoratedBox(
        decoration: sheetDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                spacing: 12.w,
                children: [
                  SizedBox.square(
                    dimension: 50.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: NetworkImageWidget(url: playlist.image?.last.url ?? ''),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Text(
                            (playlist.name ?? '').formatSongTitle,
                            maxLines: (playlist.description ?? '').isNotEmpty ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        if ((playlist.description ?? '').isNotEmpty)
                          Text(
                            playlist.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              MusicSheetMenu(
                icon:
                    DatabaseHandler.isPlaylistLiked(playlist)
                        ? Assets.icons.icHeartFilled.svg(width: 20.h, height: 20.h)
                        : Assets.icons.icHeart.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: DatabaseHandler.isPlaylistLiked(playlist) ? 'Liked' : 'Like',
                onTap: () {
                  Navigator.of(context).pop(PlaylistSheetResult.liked);
                },
              ),
              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icMusicSquareAdd.svg(
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                title: 'Add as Playlist',
                onTap: () {
                  Navigator.of(context).pop(PlaylistSheetResult.addAsPlaylist);
                },
              ),
              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icQueue.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'Add to queue',
                onTap: () {
                  Navigator.of(context).pop(PlaylistSheetResult.addPlaylistSongToQueue);
                },
              ),

              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icDownload.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'Download',
                onTap: () {
                  Navigator.of(context).pop(PlaylistSheetResult.download);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// For show sheet
  static void show(BuildContext context, {required DbPlaylistModel playlist}) {
    showModalBottomSheet<PlaylistSheetResult>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.95,
      builder: (context) {
        return PlaylistOptionSheetWidget(playlist: playlist);
      },
    ).then((value) {
      if (value != null) {
        switch (value) {
          case PlaylistSheetResult.liked:
            DatabaseHandler.toggleLikedPlaylist(playlist);
          case PlaylistSheetResult.addAsPlaylist:
            if (playlist.name == null || (playlist.songs ?? []).isEmpty) {
              return;
            }
            final list = AppDB.playlistManager.songPlaylist.toList();
            if (!list.any((element) => element.name == playlist.name)) {
              final model = DbSongPlaylistModel(
                name: playlist.name!,
                id: '${DateTime.now().millisecondsSinceEpoch}',
                image: playlist.image?.last.url ?? imageUrl,
                songs: playlist.songs!,
              );
              list.add(model);
              AppDB.playlistManager.songPlaylist = list;
              'Album added in playlist successfully'.showSuccessAlert();
            } else {
              'Please enter unique name of playlist'.showErrorAlert();
            }
          case PlaylistSheetResult.addPlaylistSongToQueue:
            if ((playlist.songs ?? []).isEmpty) {
              return;
            }
            Injector.instance<AudioCubit>().addSongsToQueue(playlist.songs!);
          case PlaylistSheetResult.download:
            'album.songs : ${playlist.songs?.length}'.logD;
            if ((playlist.songs ?? []).isEmpty) {
              return;
            }

            if (context.mounted) {
              SongQualitySheetWidget.show(
                context,
                onDownloadTap: (quality) async {
                  final res = await Future.wait([
                    ...playlist.songs!.map(
                      (e) => Injector.instance<AudioCubit>().downloadSong(song: e, quality: quality, showToast: false),
                    ),
                  ]);

                  '${res.length} songs downloaded successfully'.showSuccessAlert();
                },
              );
            }
        }
      }
    });
  }
}

///
enum PlaylistSheetResult {
  ///
  liked,

  ///
  addAsPlaylist,

  ///
  addPlaylistSongToQueue,

  ///
  download,
}
