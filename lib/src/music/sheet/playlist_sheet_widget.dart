import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/music/sheet/music_sheet_widget.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Playlist sheet widget
class PlaylistSheetWidget extends StatelessWidget {
  /// Default constructor
  const PlaylistSheetWidget({required this.song, super.key});

  /// For add Song into Playlist
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
        child: SingleChildScrollView(
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
                title: 'Add new Playlist',
                icon: const Icon(Icons.add),
                onTap: () {
                  Navigator.of(context).pop();
                  context.goNamed(AppRoutes.libraryPage, extra: {'song': song});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// For show sheet
  static void show(BuildContext context, {required DbSongModel song}) {
    showModalBottomSheet<dynamic>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (context) {
        return PlaylistSheetWidget(song: song);
      },
    );
  }
}
