import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/sheet/album_sheet_widget.dart';
import 'package:musicly/src/music/sheet/artist_sheet_widget.dart';
import 'package:musicly/src/music/sheet/playlist_sheet_widget.dart';
import 'package:musicly/src/music/sheet/song_quality_sheet_widget.dart';
import 'package:musicly/src/music/widgets/music_icon.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Music sheet widget
class MusicSheetWidget extends StatelessWidget {
  /// Default constructor
  const MusicSheetWidget({required this.song, super.key});

  /// Display song detail in sheet
  final DbSongModel song;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: DecoratedBox(
        decoration: sheetDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: BlocSelector<AudioCubit, AudioState, String?>(
            selector: (state) => state.song?.id,
            builder: (context, songId) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    spacing: 12.w,
                    children: [
                      SizedBox.square(
                        dimension: 50.h,
                        child: ClipOval(child: NetworkImageWidget(url: song.image?.last.url ?? '')),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              child: Text(
                                (song.name ?? '').formatSongTitle,
                                maxLines: (song.label ?? '').isNotEmpty ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                            if ((song.label ?? '').isNotEmpty)
                              Text(
                                song.label ?? '',
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
                        DatabaseHandler.isSongLiked(song)
                            ? Assets.icons.icHeartFilled.svg(width: 20.h, height: 20.h)
                            : Assets.icons.icHeart.svg(
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                    title: DatabaseHandler.isSongLiked(song) ? 'Liked' : 'Like',
                    onTap: () {
                      Navigator.of(context).pop(MusicSheetResult.liked);
                    },
                  ),
                  SizedBox(height: 12.h),
                  MusicSheetMenu(
                    icon: Assets.icons.icMusicSquareAdd.svg(
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    title: 'Add to Playlist',
                    onTap: () {
                      Navigator.of(context).pop(MusicSheetResult.addToPlaylist);
                    },
                  ),
                  if (song.id != songId) ...[
                    SizedBox(height: 12.h),
                    MusicSheetMenu(
                      icon: Assets.icons.icQueue.svg(
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      title: 'Add to queue',
                      onTap: () {
                        Navigator.of(context).pop(MusicSheetResult.addToQueue);
                      },
                    ),
                  ],
                  if (song.album != null) ...[
                    SizedBox(height: 12.h),
                    MusicSheetMenu(
                      icon: Assets.icons.icViewAlbum.svg(
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      title: 'View Album',
                      onTap: () {
                        Navigator.of(context).pop(MusicSheetResult.viewAlbum);
                      },
                    ),
                  ],
                  if ((song.artists?.primary ?? []).isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    MusicSheetMenu(
                      icon: Assets.icons.icViewArtist.svg(
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      title: 'View Artist',
                      onTap: () {
                        Navigator.of(context).pop(MusicSheetResult.viewArtist);
                      },
                    ),
                  ],
                  if (!DatabaseHandler.isDownloaded(song)) ...[
                    SizedBox(height: 12.h),
                    MusicSheetMenu(
                      icon: Assets.icons.icDownload.svg(
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      title: 'Download',
                      onTap: () {
                        Navigator.of(context).pop(MusicSheetResult.download);
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// For show sheet
  static void show(BuildContext context, {required DbSongModel song}) {
    showModalBottomSheet<MusicSheetResult>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.95,
      builder: (context) {
        return MusicSheetWidget(song: song);
      },
    ).then((value) {
      if (value != null) {
        switch (value) {
          case MusicSheetResult.liked:
            DatabaseHandler.toggleLikedSong(song, showToast: true);
          case MusicSheetResult.addToPlaylist:
            if (context.mounted) PlaylistSheetWidget.show(context, song: song);
          case MusicSheetResult.addToQueue:
            Injector.instance<AudioCubit>().addSongToQueue(song);
          case MusicSheetResult.viewAlbum:
            if (context.mounted) AlbumSheetWidget.show(context, song: song);
          case MusicSheetResult.viewArtist:
            if (context.mounted) ArtistSheetWidget.show(context, song: song);
          case MusicSheetResult.download:
            if (context.mounted) {
              SongQualitySheetWidget.show(
                context,
                onDownloadTap: (quality) {
                  Injector.instance<AudioCubit>().downloadSong(song: song, quality: quality);
                },
              );
            }
        }
      }
    });
  }
}

/// Music sheet menu
class MusicSheetMenu extends StatelessWidget {
  /// Default constructor
  const MusicSheetMenu({required this.title, this.icon, super.key, this.onTap});

  /// For display icon
  final Widget? icon;

  /// For display title
  final String title;

  /// For handle on tap
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        spacing: 12.w,
        children: [
          if (icon != null) MusicIcon.medium(icon: icon!),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF282C30),
                borderRadius: BorderRadius.circular(26.r),
                border: const Border(top: BorderSide(color: Color(0xFF424750), width: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF262E32).withValues(alpha: 0.7),
                    blurRadius: 20,
                    offset: const Offset(-3, -3),
                  ),
                  BoxShadow(
                    color: const Color(0xFF101012).withValues(alpha: 0.75),
                    blurRadius: 20,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Text(title, style: context.textTheme.bodyMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Music Sheet result
enum MusicSheetResult {
  /// Update Liked
  liked,

  /// Add to Playlist
  addToPlaylist,

  /// Add to Queue
  addToQueue,

  /// View Album
  viewAlbum,

  /// View Artist
  viewArtist,

  /// Download
  download,
}
