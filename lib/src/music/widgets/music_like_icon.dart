import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/gen/assets.gen.dart';

/// For Display Music Like Icon
class MusicLikeIcon extends StatelessWidget {
  /// For Display Music Like Icon
  const MusicLikeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioCubit>();
    return BlocSelector<AudioCubit, AudioState, bool>(
      selector: (state) => state.song?.isLiked ?? false,
      builder: (context, isLiked) {
        return IconButton(
          onPressed: cubit.toggleLikeSong,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder:
                (child, animation) =>
                    ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child)),
            child:
                isLiked
                    ? Assets.icons.icLike.svg(
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      key: ValueKey('liked-${cubit.state.song?.id}'),
                    )
                    : Assets.icons.icLike.svg(key: ValueKey('unliked-${cubit.state.song?.id}')),
          ),
        );
      },
    );
  }
}
