import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';

/// For displaying music time indicator
class MusicTimeIndicatorWidget extends StatelessWidget {
  /// Music Time Indicator Widget Constructor
  const MusicTimeIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      buildWhen:
          (previous, current) => current.duration != previous.duration || current.positioned != previous.positioned,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(state.positioned.toString().split('.')[0], style: Theme.of(context).textTheme.bodyMedium),
            Text(state.duration.toString().split('.')[0], style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      },
    );
  }
}
