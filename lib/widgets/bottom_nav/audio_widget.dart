import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/audio_play_state.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Audio Widget
class AudioWidget extends StatelessWidget {
  /// Audio Widget Constructor
  const AudioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = Injector.instance<AudioCubit>();
    return BlocBuilder<AudioCubit, AudioState>(
      buildWhen: (previous, current) => previous.playState != current.playState,
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
                children: [
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
                  SizedBox.shrink(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
