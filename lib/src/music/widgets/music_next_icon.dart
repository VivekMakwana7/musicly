import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/widgets/music_icon.dart';

/// For display music next icon
class MusicNextIcon extends StatelessWidget {
  /// Music Next Icon Constructor
  const MusicNextIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioCubit>();
    return BlocSelector<AudioCubit, AudioState, bool>(
      selector: (state) => state.isNextDisabled,
      builder: (context, isDisabled) {
        return MusicIcon.medium(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder:
                (child, animation) =>
                    ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child)),
            child:
                isDisabled
                    ? Assets.icons.icNext.svg(key: ValueKey('song-next-disabled-${cubit.state.song?.id}'))
                    : Assets.icons.icNext.svg(
                      key: ValueKey('song-next-${cubit.state.song?.id}'),
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
          ),
          onTap: isDisabled ? () {} : cubit.playNextSong,
        );
      },
    );
  }
}
