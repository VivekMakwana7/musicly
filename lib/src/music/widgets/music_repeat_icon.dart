import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/widgets/music_icon.dart';

/// For display music repeat icon
class MusicRepeatIcon extends StatelessWidget {
  /// Music Repeat Icon Constructor
  const MusicRepeatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioCubit>();
    return BlocSelector<AudioCubit, AudioState, bool>(
      selector: (state) => state.songSources.length == 1,
      builder: (context, isDisabled) {
        return MusicIcon.small(
          icon: BlocSelector<AudioCubit, AudioState, bool>(
            selector: (state) => state.isRepeat,
            builder: (context, isRepeat) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                transitionBuilder:
                    (child, animation) =>
                        ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child)),
                child:
                    !isDisabled && isRepeat
                        ? Assets.icons.icRepeat.svg(
                          key: ValueKey('song-repeat-${cubit.state.song?.id}'),
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        )
                        : Assets.icons.icRepeat.svg(key: ValueKey('song-unrepeat-${cubit.state.song?.id}')),
              );
            },
          ),
          onTap: isDisabled ? null : cubit.toggleRepeatSong,
        );
      },
    );
  }
}
