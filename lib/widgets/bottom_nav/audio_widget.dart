import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/audio_play_state.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/music/widgets/music_seek_bar_widget.dart';
import 'package:musicly/widgets/bottom_nav/audio_loading_widget.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Audio Widget
class AudioWidget extends StatelessWidget {
  /// Audio Widget Constructor
  const AudioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = Injector.instance<AudioCubit>();
    return BlocBuilder<AudioCubit, AudioState>(
      buildWhen: (previous, current) => previous.playState != current.playState || previous.song != current.song,
      builder: (context, state) {
        if (state.playState == AudioPlayState.idle) {
          return const SizedBox.shrink();
        }

        if (state.playState == AudioPlayState.loading) {
          return const AudioLoadingWidget();
        }

        return Padding(
          padding: const EdgeInsets.all(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C3036), Color(0xFF31343C)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: GestureDetector(
                    onTap: () {
                      final fullHistoryUris =
                          appRouter.routerDelegate.currentConfiguration.matches.map((e) => e.matchedLocation).toList();

                      switch (Injector.instance<AppCubit>().state) {
                        case ArtistSongPlay(artistId: final artistId)
                            when fullHistoryUris.last != AppRoutes.artistDetailPage.navPath:
                          context.pushNamed(AppRoutes.artistDetailPage, extra: {'artistId': artistId});
                        case AlbumSongPlay(albumId: final albumId)
                            when fullHistoryUris.last != AppRoutes.albumDetailPage.navPath:
                          context.pushNamed(AppRoutes.albumDetailPage, extra: {'albumId': albumId});
                        case PlaylistSongPlay(playlistId: final playlistId)
                            when fullHistoryUris.last != AppRoutes.playlistDetailPage.navPath:
                          context.pushNamed(AppRoutes.playlistDetailPage, extra: {'playlistId': playlistId});
                        case LibrarySongPlay(libraryId: final libraryId)
                            when fullHistoryUris.last != AppRoutes.libraryDetailPage.navPath:
                          context.pushNamed(AppRoutes.libraryDetailPage, extra: {'libraryId': libraryId});
                        case _:
                          context.pushNamed(AppRoutes.musicPlayerPage);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      spacing: 12.w,
                      children: <Widget>[
                        SizedBox.square(
                          dimension: 50.h,
                          child: ClipOval(child: NetworkImageWidget(url: state.song?.image?.last.url ?? '')),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Flexible(
                                child: Text(
                                  state.song?.name ?? '',
                                  maxLines: (state.song?.label ?? '').isNotEmpty ? 1 : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodyMedium,
                                ),
                              ),
                              if ((state.song?.label ?? '').isNotEmpty)
                                Text(
                                  state.song?.label ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            BlocSelector<AudioCubit, AudioState, bool>(
                              selector: (state) => state.isPrevDisabled,
                              builder: (context, isDisabled) {
                                return IconButton(
                                  onPressed: isDisabled ? () {} : cubit.playPreviousSong,
                                  icon:
                                      isDisabled
                                          ? Assets.icons.icPrevious.svg(
                                            key: const ValueKey('bottom-nav-previous-disabled-button'),
                                          )
                                          : Assets.icons.icPrevious.svg(
                                            key: const ValueKey('bottom-nav-previous-button'),
                                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                          ),
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                );
                              },
                            ),
                            BlocSelector<AudioCubit, AudioState, AudioPlayState>(
                              selector: (state) => state.playState,
                              builder: (context, playState) {
                                return IconButton(
                                  onPressed: cubit.togglePlayPause,
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 240),
                                    child:
                                        playState.isPlay
                                            ? Assets.icons.icPause.svg(key: const ValueKey('bottom-nav-ic-pause'))
                                            : Assets.icons.icPlay.svg(
                                              key: const ValueKey('bottom-nav-ic-play'),
                                              height: 20.h,
                                            ),
                                  ),
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                );
                              },
                            ),
                            BlocSelector<AudioCubit, AudioState, bool>(
                              selector: (state) => state.isNextDisabled,
                              builder: (context, isDisabled) {
                                return IconButton(
                                  onPressed: isDisabled ? () {} : cubit.playNextSong,
                                  icon:
                                      isDisabled
                                          ? Assets.icons.icNext.svg(
                                            key: const ValueKey('bottom-nav-next-disabled-button'),
                                          )
                                          : Assets.icons.icNext.svg(
                                            key: const ValueKey('bottom-nav-next-button'),
                                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                          ),
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10.w), child: const MusicSeekBarWidget()),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
