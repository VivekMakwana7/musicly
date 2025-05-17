import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/music/sheet/music_sheet_widget.dart';
import 'package:musicly/widgets/network_image_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// For display Detail page's song listing
class DetailSongListingWidget extends StatelessWidget {
  /// Detail Song Listing Widget constructor
  const DetailSongListingWidget({
    required this.songs,
    super.key,
    this.onTap,
    this.onViewAllTap,
    this.hideAction = false,
  });

  /// For display Skeletonized widget
  factory DetailSongListingWidget.loading() => const DetailSongListingWidget(songs: []);

  /// List of Songs
  final List<DbSongModel> songs;

  /// For handle extra activity on Item Tap
  final void Function(int index)? onTap;

  /// For handle View all tap
  final VoidCallback? onViewAllTap;

  /// For hide action widget
  final bool hideAction;

  @override
  Widget build(BuildContext context) {
    final isLoading = songs.isEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F22),
        borderRadius: BorderRadius.circular(26.r),
        border: const Border(top: BorderSide(color: Color(0xFF424750), width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF262E32).withValues(alpha: 0.7),
            blurRadius: 20,
            offset: const Offset(-3, -3),
          ),
          BoxShadow(color: const Color(0xFF101012).withValues(alpha: 0.75), blurRadius: 20, offset: const Offset(4, 4)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeletonizer(
              enabled: isLoading,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Songs', style: context.textTheme.titleSmall?.copyWith(fontWeight: semiBoldFontWeight)),
                  if (onViewAllTap != null)
                    TextButton(
                      onPressed: onViewAllTap,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                      child: Text(
                        'View All',
                        style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD)),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            BlocSelector<AudioCubit, AudioState, String?>(
              selector: (state) => state.song?.id,
              builder: (context, songId) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final image = isLoading ? imageUrl : songs[index].image?.last.url ?? '';
                    final title = isLoading ? 'Song title' : songs[index].name ?? '';
                    final description =
                        isLoading
                            ? 'Song description'
                            : '${songs[index].label} | ${songs[index].artists?.primary?.first.name ?? ''}';
                    final isPlaying = !isLoading && songs[index].id == songId;

                    Widget imageWidget = NetworkImageWidget(url: image, height: 52.h, width: 52.h);
                    if (isPlaying) {
                      imageWidget = Stack(
                        children: [
                          imageWidget,
                          Positioned.fill(
                            child: ColoredBox(
                              color: AppColors.primary.withValues(alpha: 0.8),
                              child: Center(child: Assets.json.songPlay.lottie(height: 20.h, width: 20.h)),
                            ),
                          ),
                        ],
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        if (!isLoading) {
                          if (isPlaying) {
                            context.pushNamed(AppRoutes.musicPlayerPage);
                          } else {
                            onTap?.call(index);
                          }
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Skeletonizer(
                        enabled: isLoading,
                        child: Row(
                          spacing: 12.w,
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(12.r), child: imageWidget),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4.h,
                                children: [
                                  Flexible(
                                    child: Text(
                                      title.formatSongTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ),
                                  Text(
                                    description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            if (!hideAction) ...[
                              IconButton(
                                icon: Assets.icons.icMore.svg(
                                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                ),
                                onPressed: () {
                                  MusicSheetWidget.show(context, song: songs[index]);
                                },
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemCount: isLoading ? 5 : songs.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
