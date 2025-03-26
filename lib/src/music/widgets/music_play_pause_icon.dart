import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/enums/audio_play_state.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/widgets/music_icon.dart';

/// For display music play pause icon
class MusicPlayPauseIcon extends StatelessWidget {
  /// Music Play Pause Icon Constructor
  const MusicPlayPauseIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioCubit>();
    return BlocSelector<AudioCubit, AudioState, AudioPlayState>(
      selector: (state) => state.playState,
      builder: (context, playState) {
        return MusicIcon.large(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder:
                (child, animation) =>
                    ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child)),
            child:
                playState.isPlay
                    ? Assets.icons.icPause.svg(
                      height: 24.h,
                      width: 24.h,
                      key: ValueKey('song-pause-${cubit.state.song?.id}'),
                    )
                    : Assets.icons.icPlay.svg(
                      height: 24.h,
                      width: 24.h,
                      key: ValueKey('song-play-${cubit.state.song?.id}'),
                    ),
          ),
          onTap: cubit.togglePlayPause,
        );
      },
    );
  }
}
