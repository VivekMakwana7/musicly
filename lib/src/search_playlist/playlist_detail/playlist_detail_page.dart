import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/models/playlist/db_playlist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:musicly/src/search_playlist/playlist_detail/cubit/playlist_detail_cubit.dart';
import 'package:musicly/src/search_playlist/playlist_detail/playlist_option_sheet_widget.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/app_more_button.dart';
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppBackButton(),
                    BlocSelector<PlaylistDetailCubit, PlaylistDetailState, DbPlaylistModel?>(
                      selector: (state) => state.playlist,
                      builder: (context, playlist) {
                        return AppMoreButton(
                          onTap: () {
                            PlaylistOptionSheetWidget.show(context, playlist: playlist!);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<PlaylistDetailCubit, PlaylistDetailState>(
                buildWhen: (previous, current) => current.apiState != previous.apiState,
                builder: (context, state) {
                  return switch (state.apiState) {
                    ApiState.success => Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                Injector.instance<AudioCubit>().loadSourceData(
                                  type: SourceType.searchPlaylist,
                                  songId: state.playlist!.songs![index].id,
                                  songs: state.playlist!.songs!,
                                  page: 0,
                                  isPaginated: false,
                                );
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
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
        bottomNavigationBar: const AudioWidget(),
      ),
    );
  }
}
