import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/widgets/music_icon.dart';

/// For display music shuffle icon
class MusicShuffleIcon extends StatelessWidget {
  /// Music Shuffle Icon Constructor
  const MusicShuffleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioCubit>();
    return BlocSelector<AudioCubit, AudioState, bool>(
      selector: (state) => state.currentIndex == 0,
      builder: (context, isDisabled) {
        return BlocSelector<AudioCubit, AudioState, bool>(
          selector: (state) => state.isShuffle,
          builder: (context, isShuffle) {
            return MusicIcon.small(
              onTap: isDisabled ? null : cubit.toggleShuffleSong,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                transitionBuilder:
                    (child, animation) =>
                        ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child)),
                child:
                    !isDisabled && isShuffle
                        ? Assets.icons.icShuffle.svg(
                          key: ValueKey('song-shuffled-${cubit.state.song?.id}'),
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        )
                        : Assets.icons.icShuffle.svg(key: ValueKey('song-unshuffled-${cubit.state.song?.id}')),
              ),
            );
          },
        );
      },
    );
  }
}
