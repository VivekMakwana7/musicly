import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/music/widgets/music_icon.dart';

/// For display music repeat icon
class MusicRepeatIcon extends StatelessWidget {
  /// Music Repeat Icon Constructor
  const MusicRepeatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioCubit>();
    return MusicIcon.small(
      icon: BlocSelector<AudioCubit, AudioState, LoopMode>(
        selector: (state) => state.loopMode,
        builder: (context, loopMode) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder:
                (child, animation) =>
                    ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child)),
            child: switch (loopMode) {
              LoopMode.off => Assets.icons.icRepeat.svg(key: ValueKey('song-unrepeat-${cubit.state.song?.id}')),
              LoopMode.one => Stack(
                alignment: Alignment.center,
                children: [
                  Assets.icons.icRepeat.svg(
                    key: ValueKey('song-repeat-one-${cubit.state.song?.id}'),
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  Text('1', style: context.textTheme.bodyMedium?.copyWith(fontSize: 8.sp, fontWeight: boldFontWeight)),
                ],
              ),
              LoopMode.all => Assets.icons.icRepeat.svg(
                key: ValueKey('song-repeat-${cubit.state.song?.id}'),
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            },
          );
        },
      ),
      onTap: cubit.toggleRepeatSong,
    );
  }
}
