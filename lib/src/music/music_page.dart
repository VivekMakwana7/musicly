import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/cubits/connection_checker_cubit.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/src/music/sheet/music_sheet_widget.dart';
import 'package:musicly/src/music/widgets/music_like_icon.dart';
import 'package:musicly/src/music/widgets/music_next_icon.dart';
import 'package:musicly/src/music/widgets/music_play_pause_icon.dart';
import 'package:musicly/src/music/widgets/music_prev_icon.dart';
import 'package:musicly/src/music/widgets/music_repeat_icon.dart';
import 'package:musicly/src/music/widgets/music_seek_bar_widget.dart';
import 'package:musicly/src/music/widgets/music_shuffle_icon.dart';
import 'package:musicly/src/music/widgets/music_time_indicator_widget.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/app_more_button.dart';
import 'package:musicly/widgets/detail_description_widget.dart';
import 'package:musicly/widgets/detail_image_view.dart';
import 'package:musicly/widgets/detail_title_widget.dart';

/// For Display Music Page
class MusicPage extends StatelessWidget {
  /// Music Page Constructor
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectionCheckerCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppBackButton(),
                    BlocSelector<ConnectionCheckerCubit, bool, bool>(
                      selector: (state) => state,
                      builder: (context, isConnected) {
                        if (!isConnected) {
                          return const SizedBox.shrink();
                        }
                        return AppMoreButton(
                          onTap: () {
                            MusicSheetWidget.show(
                              context,
                              song: context.read<AudioCubit>().state.song!,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                child: BlocBuilder<AudioCubit, AudioState>(
                  buildWhen:
                      (previous, current) => current.song != previous.song,
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 80.h),
                        DetailImageView(
                          imageUrl: state.song?.image?.last.url ?? '',
                          dimension: context.height * 0.3,
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8.h,
                                  children: [
                                    DetailTitleWidget(
                                      title:
                                          (state.song?.name ?? '')
                                              .formatSongTitle,
                                      maxLines: 2,
                                    ),
                                    DetailDescriptionWidget(
                                      description: state.song?.label ?? '',
                                    ),
                                  ],
                                ),
                              ),
                              const MusicLikeIcon(),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: const MusicSeekBarWidget(),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: const MusicTimeIndicatorWidget(),
                        ),
                        SizedBox(height: 16.h),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2C3036), Color(0xFF31343C)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF101012,
                                ).withValues(alpha: 0.5),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2C3036),
                                      Color(0xFF31343C),
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                  borderRadius: BorderRadius.circular(50.r),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFF101012),
                                      blurRadius: 22.3,
                                      offset: Offset(8, 8),
                                    ),
                                    BoxShadow(
                                      color: Color(0xFF485057),
                                      blurRadius: 22.3,
                                      offset: Offset(-5.2, -5.2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2.w),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF2F353A),
                                          Color(0xFF1C1F22),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18.w,
                                        vertical: 10.h,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MusicShuffleIcon(),
                                          MusicPrevIcon(),
                                          MusicPlayPauseIcon(),
                                          MusicNextIcon(),
                                          MusicRepeatIcon(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
