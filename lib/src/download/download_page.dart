import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:musicly/src/download/cubit/cubit/download_cubit.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/detail_song_listing_widget.dart';

/// Download Page
class DownloadPage extends StatelessWidget {
  /// Download Page Constructor
  const DownloadPage({super.key, this.havingInternet = true});

  /// For display Audio widget if Not having Internet
  final bool havingInternet;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadCubit(),
      child: Scaffold(
        body: BlocBuilder<DownloadCubit, DownloadState>(
          builder: (context, state) {
            final cubit = context.read<DownloadCubit>();
            return SafeArea(
              child: StreamBuilder(
                stream: cubit.downloadStream,
                builder: (context, snapshot) {
                  final list = AppDB.downloadManager.downloadedSongs;

                  if (list.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Center(
                        child: Text(
                          'Your offline music library is empty! Tap the download icon next to any song to listen offline, anytime, anywhere.',
                          style: context.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: DetailSongListingWidget(
                      songs: list,
                      onTap: (index) {
                        Injector.instance<AppCubit>().resetState();
                        Injector.instance<AudioCubit>().loadSourceData(
                          type: SourceType.downloaded,
                          songId: list[index].id,
                          page: 0,
                          isPaginated: false,
                          songs: list,
                        );
                      },
                      hideAction: true,
                    ),
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: havingInternet ? const SizedBox.shrink() : const AudioWidget(),
      ),
    );
  }
}
