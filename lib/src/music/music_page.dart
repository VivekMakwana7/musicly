import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
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
    context.read<AudioCubit>().checkLike();
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state is SongLikeUpdate) {
          context.read<AudioCubit>().toggleLikeSong(isLiked: state.isLiked);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppBackButton(),
                    AppMoreButton(
                      onTap: () {
                        MusicSheetWidget.show(context, song: context.read<AudioCubit>().state.song!);
                      },
                    ),
                  ],
                ),
                Flexible(
                  child: BlocBuilder<AudioCubit, AudioState>(
                    buildWhen: (previous, current) => current.song != previous.song,
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 80.h),
                          DetailImageView(imageUrl: state.song?.image?.last.url ?? '', dimension: context.height * 0.3),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8.h,
                                  children: [
                                    DetailTitleWidget(title: state.song?.name ?? '', maxLines: 2),
                                    DetailDescriptionWidget(description: state.song?.label ?? ''),
                                  ],
                                ),
                              ),
                              const MusicLikeIcon(),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          const MusicSeekBarWidget(),
                          SizedBox(height: 8.h),
                          const MusicTimeIndicatorWidget(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MusicShuffleIcon(),
                                MusicPrevIcon(),
                                MusicPlayPauseIcon(),
                                MusicNextIcon(),
                                MusicRepeatIcon(),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
