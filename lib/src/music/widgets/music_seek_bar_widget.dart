import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';

/// Music Seek Bar Widget
class MusicSeekBarWidget extends StatelessWidget {
  /// Music Seek Bar Widget Constructor
  const MusicSeekBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = Injector.instance<AudioCubit>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocBuilder<AudioCubit, AudioState>(
          buildWhen:
              (previous, current) => current.duration != previous.duration || current.positioned != previous.positioned,
          builder: (context, state) {
            return GestureDetector(
              onPanDown: (details) {
                cubit.seekToPosition(details.localPosition.dx, constraints.maxWidth);
              },
              behavior: HitTestBehavior.opaque,
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
    );
  }
}
