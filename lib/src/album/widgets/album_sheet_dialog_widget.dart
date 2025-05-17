import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
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

/// For display Album sheet dialog
class AlbumSheetDialogWidget extends StatelessWidget {
  /// Album Sheet Dialog Widget constructor
  const AlbumSheetDialogWidget({required this.album, super.key});

  /// for display album details
  final DbAlbumModel album;

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
                    child: ClipOval(child: NetworkImageWidget(url: album.image?.last.url ?? '')),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Text(
                            (album.name ?? '').formatSongTitle,
                            maxLines: (album.description ?? '').isNotEmpty ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        if ((album.description ?? '').isNotEmpty)
                          Text(
                            album.description ?? '',
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
                    DatabaseHandler.isAlbumLiked(album)
                        ? Assets.icons.icHeartFilled.svg(width: 20.h, height: 20.h)
                        : Assets.icons.icHeart.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: DatabaseHandler.isAlbumLiked(album) ? 'Liked' : 'Like',
                onTap: () {
                  Navigator.of(context).pop(AlbumSheetResult.liked);
                },
              ),
              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icMusicSquareAdd.svg(
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                title: 'Add as Playlist',
                onTap: () {
                  Navigator.of(context).pop(AlbumSheetResult.addAsPlaylist);
                },
              ),
              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icQueue.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'Add to queue',
                onTap: () {
                  Navigator.of(context).pop(AlbumSheetResult.addAlbumSongToQueue);
                },
              ),

              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icDownload.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'Download',
                onTap: () {
                  Navigator.of(context).pop(AlbumSheetResult.download);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// For show sheet
  static void show(BuildContext context, {required DbAlbumModel album}) {
    showModalBottomSheet<AlbumSheetResult>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.95,
      builder: (context) {
        return AlbumSheetDialogWidget(album: album);
      },
    ).then((value) {
      if (value != null) {
        switch (value) {
          case AlbumSheetResult.liked:
            DatabaseHandler.toggleLikedAlbum(album);
          case AlbumSheetResult.addAsPlaylist:
            if (album.name == null || (album.songs ?? []).isEmpty) {
              return;
            }
            final list = AppDB.playlistManager.songPlaylist.toList();
            if (!list.any((element) => element.name == album.name)) {
              final model = DbSongPlaylistModel(
                name: album.name!,
                id: '${DateTime.now().millisecondsSinceEpoch}',
                image: album.image?.last.url ?? imageUrl,
                songs: album.songs!,
              );
              list.add(model);
              AppDB.playlistManager.songPlaylist = list;
              'Album added in playlist successfully'.showSuccessAlert();
            } else {
              'Please enter unique name of playlist'.showErrorAlert();
            }
          case AlbumSheetResult.addAlbumSongToQueue:
            if ((album.songs ?? []).isEmpty) {
              return;
            }
            Injector.instance<AudioCubit>().addSongsToQueue(album.songs!);
          case AlbumSheetResult.download:
            'album.songs : ${album.songs?.length}'.logD;
            if ((album.songs ?? []).isEmpty) {
              return;
            }

            if (context.mounted) {
              SongQualitySheetWidget.show(
                context,
                onDownloadTap: (quality) async {
                  final res = await Future.wait([
                    ...album.songs!.map(
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
enum AlbumSheetResult {
  ///
  liked,

  ///
  addAsPlaylist,

  ///
  addAlbumSongToQueue,

  ///
  download,
}
