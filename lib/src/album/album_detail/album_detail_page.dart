import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/models/album/db_album_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:musicly/src/album/album_detail/cubit/album_detail_cubit.dart';
import 'package:musicly/src/album/widgets/album_sheet_dialog_widget.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/app_more_button.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/detail_artist_listing_widget.dart';
import 'package:musicly/widgets/detail_description_widget.dart';
import 'package:musicly/widgets/detail_image_view.dart';
import 'package:musicly/widgets/detail_song_listing_widget.dart';
import 'package:musicly/widgets/detail_title_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// For display Album Detail page
class AlbumDetailPage extends StatelessWidget {
  /// Album Detail Page constructor
  const AlbumDetailPage({required this.albumId, super.key});

  /// For get album detail
  final String albumId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumDetailCubit(albumId: albumId),
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
                    BlocSelector<AlbumDetailCubit, AlbumDetailState, DbAlbumModel?>(
                      selector: (state) => state.album,
                      builder: (context, album) {
                        if (album == null) {
                          return const SizedBox.shrink();
                        }
                        return AppMoreButton(
                          onTap: () {
                            AlbumSheetDialogWidget.show(context, album: album);
                          },
                        );
                      },
                    ),
                  ],
                ),
                BlocBuilder<AlbumDetailCubit, AlbumDetailState>(
                  buildWhen: (previous, current) => current.apiState != previous.apiState,
                  builder: (context, state) {
                    return switch (state.apiState) {
                      ApiState.success => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            DetailImageView(imageUrl: state.album?.image?.last.url ?? ''),
                            SizedBox(height: 30.h),
                            DetailTitleWidget(title: state.album?.name ?? ''),
                            if (state.album?.description != null) ...[
                              SizedBox(height: 6.h),
                              DetailDescriptionWidget(description: state.album!.description!),
                            ],
                            SizedBox(height: 30.h),
                            if (state.album?.songs != null && state.album!.songs!.isNotEmpty) ...[
                              DetailSongListingWidget(
                                songs: state.album!.songs!,
                                onTap: (index) {
                                  Injector.instance<AppCubit>().albumSongPlayed(albumId);
                                  Injector.instance<AudioCubit>().loadSourceData(
                                    type: SourceType.searchAlbum,
                                    songId: state.album!.songs![index].id,
                                    songs: state.album!.songs!,
                                    page: 0,
                                    isPaginated: false,
                                  );
                                },
                              ),
                              SizedBox(height: 30.h),
                            ],
                            if (state.album?.artists?.primary != null && state.album!.artists!.primary!.isNotEmpty)
                              DetailArtistListingWidget(artists: state.album!.artists!.primary!),
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
                            const Skeletonizer(child: DetailTitleWidget(title: 'Album Title')),
                            SizedBox(height: 6.h),
                            const Skeletonizer(child: DetailDescriptionWidget(description: 'Album description')),
                            SizedBox(height: 30.h),
                            DetailSongListingWidget.loading(),
                            SizedBox(height: 30.h),
                            DetailArtistListingWidget.loading(),
                          ],
                        ),
                      ),
                      _ => const SizedBox.shrink(),
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
