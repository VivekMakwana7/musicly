import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/sheet/playlist_sheet_widget.dart';
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF353A40), Color(0xFF101010), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                    child: ClipOval(child: NetworkImageWidget(url: song.image?.last.url ?? '')),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Text(
                            song.name ?? '',
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
                icon: Assets.icons.icLike.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'Like',
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
              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icQueue.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'Add to queue',
              ),
              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icViewAlbum.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'View Album',
              ),
              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icViewArtist.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'View Artist',
              ),
              SizedBox(height: 12.h),
              MusicSheetMenu(
                icon: Assets.icons.icLyrics.svg(colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                title: 'View Lyrics',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// For show sheet
  static void show(BuildContext context, {required DbSongModel song}) {
    showModalBottomSheet<MusicSheetResult>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
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
          case MusicSheetResult.viewAlbum:
          case MusicSheetResult.viewArtist:
          case MusicSheetResult.viewLyrics:
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
          if(icon != null) MusicIcon.medium(icon: icon!),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF282C30),
                borderRadius: BorderRadius.circular(26.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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

  /// View Lyrics
  viewLyrics,
}
