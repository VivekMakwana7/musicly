import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/audio_play_state.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/gen/assets.gen.dart';
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

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
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
                        selector: (state) => state.currentIndex == 0,
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
                            style: IconButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
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
                            style: IconButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                          );
                        },
                      ),
                      BlocSelector<AudioCubit, AudioState, bool>(
                        selector: (state) => state.currentIndex == state.songSources.length - 1,
                        builder: (context, isDisabled) {
                          return IconButton(
                            onPressed: isDisabled ? () {} : cubit.playNextSong,
                            icon:
                                isDisabled
                                    ? Assets.icons.icNext.svg(key: const ValueKey('bottom-nav-next-disabled-button'))
                                    : Assets.icons.icNext.svg(
                                      key: const ValueKey('bottom-nav-next-button'),
                                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                    ),
                            style: IconButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return BlocBuilder<AudioCubit, AudioState>(
                    buildWhen:
                        (previous, current) =>
                            current.duration != previous.duration || current.positioned != previous.positioned,
                    builder: (context, state) {
                      return GestureDetector(
                        onPanDown: (details) {
                          cubit.seekToPosition(details.localPosition.dx, constraints.maxWidth);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: SizedBox(
                            height: 6.h,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: .3),
                                      borderRadius: BorderRadius.all(Radius.circular(6.r)),
                                    ),
                                  ),
                                ),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFF016BB8), Color(0xFF11A8FD)]),
                                    borderRadius: BorderRadius.all(Radius.circular(6.r)),
                                  ),
                                  child: SizedBox(
                                    width:
                                        state.duration.inMilliseconds == 0
                                            ? 0
                                            : (constraints.maxWidth * state.positioned.inMilliseconds) /
                                                state.duration.inMilliseconds,
                                    height: 6.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
