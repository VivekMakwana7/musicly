import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/search_playlist/playlist_detail/cubit/playlist_detail_cubit.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/detail_artist_listing_widget.dart';
import 'package:musicly/widgets/detail_description_widget.dart';
import 'package:musicly/widgets/detail_image_view.dart';
import 'package:musicly/widgets/detail_song_listing_widget.dart';
import 'package:musicly/widgets/detail_title_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// For display Playlist detail page
class PlaylistDetailPage extends StatelessWidget {
  /// Playlist Detail Page constructor
  const PlaylistDetailPage({required this.playlistId, super.key});

  /// For get playlist details
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistDetailCubit(playlistId: playlistId),
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
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2F353A), Color(0xFF1C1F22)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: SizedBox.square(dimension: 40.h, child: Center(child: Assets.icons.icMore.svg())),
                    ),
                  ],
                ),
                BlocBuilder<PlaylistDetailCubit, PlaylistDetailState>(
                  buildWhen: (previous, current) => current.apiState != previous.apiState,
                  builder: (context, state) {
                    return switch (state.apiState) {
                      ApiState.success => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            DetailImageView(imageUrl: state.playlist?.image?.last.url ?? ''),
                            SizedBox(height: 30.h),
                            DetailTitleWidget(title: state.playlist?.name ?? ''),
                            SizedBox(height: 6.h),
                            DetailDescriptionWidget(description: state.playlist?.description ?? ''),
                            SizedBox(height: 30.h),
                            if (state.playlist?.songs != null && state.playlist!.songs!.isNotEmpty) ...[
                              DetailSongListingWidget(
                                songs: state.playlist!.songs!,
                                onTap: (index) {
                                  Injector.instance<AppCubit>().playlistSongPlayed(playlistId);
                                },
                              ),
                              SizedBox(height: 30.h),
                            ],
                            if (state.playlist?.artists != null && state.playlist!.artists!.isNotEmpty)
                              DetailArtistListingWidget(artists: state.playlist!.artists!),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                      ApiState.loading || ApiState.idle => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            const Skeletonizer(child: DetailImageView(imageUrl: imageUrl)),
                            SizedBox(height: 30.h),
                            const Skeletonizer(child: DetailTitleWidget(title: 'Playlist Title')),
                            SizedBox(height: 6.h),
                            const Skeletonizer(child: DetailDescriptionWidget(description: 'Playlist description')),
                            SizedBox(height: 30.h),
                            DetailSongListingWidget.loading(),
                            SizedBox(height: 30.h),
                            DetailArtistListingWidget.loading(),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                      _ => const SizedBox(),
                    };
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AudioWidget(),
      ),
    );
  }
}
