import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/cubits/audio/source_handler.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/artist/artist_detail/cubit/artist_detail_cubit.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/detail_album_listing_widget.dart';
import 'package:musicly/widgets/detail_bio_widget.dart';
import 'package:musicly/widgets/detail_description_widget.dart';
import 'package:musicly/widgets/detail_image_view.dart';
import 'package:musicly/widgets/detail_language_listing_widget.dart';
import 'package:musicly/widgets/detail_song_listing_widget.dart';
import 'package:musicly/widgets/detail_title_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// For display Artist Detail page
class ArtistDetailPage extends StatelessWidget {
  /// Artist Detail Page constructor
  const ArtistDetailPage({required this.artistId, super.key});

  /// For get Artist detail
  final String artistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistDetailCubit(artistId: artistId),
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
                BlocBuilder<ArtistDetailCubit, ArtistDetailState>(
                  buildWhen: (previous, current) => current.apiState != previous.apiState,
                  builder: (context, state) {
                    final artist = state.artist;
                    return switch (state.apiState) {
                      ApiState.success => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            Row(
                              spacing: 12.w,
                              children: [
                                DetailImageView(imageUrl: artist?.image?.last.url ?? '', dimension: 70.h),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      DetailTitleWidget(title: artist?.name ?? ''),
                                      DetailDescriptionWidget(description: artist?.dominantType ?? ''),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (artist?.bio != null && artist!.bio!.isNotEmpty) ...[
                              DetailBioWidget(bio: artist.bio?.first.text ?? ''),
                            ],

                            if (artist?.topSongs != null && artist!.topSongs!.isNotEmpty) ...[
                              SizedBox(height: 30.h),
                              DetailSongListingWidget(
                                songs: artist.topSongs!,
                                onTap: (index) {
                                  Injector.instance<AppCubit>().artistSongPlayed(artistId);
                                  Injector.instance<AudioCubit>().loadSourceData(
                                    type: SourceType.searchArtist,
                                    songId: artist.topSongs![index].id,
                                    songs: artist.topSongs!,
                                  );
                                },
                                onViewAllTap:
                                    artist.topSongs!.length >= 10
                                        ? () {
                                          context.pushNamed(AppRoutes.artistSongPage, extra: {'artistId': artistId});
                                        }
                                        : null,
                              ),
                            ],

                            if (artist?.topAlbums != null && artist!.topAlbums!.isNotEmpty) ...[
                              DetailAlbumListingWidget(albums: artist.topAlbums!),
                            ],

                            if (artist?.availableLanguages != null && artist!.availableLanguages!.isNotEmpty)
                              DetailLanguageListingWidget(languages: artist.availableLanguages!),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                      ApiState.loading || ApiState.idle => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            Row(
                              spacing: 12.w,
                              children: [
                                Skeletonizer(child: DetailImageView(imageUrl: imageUrl, dimension: 70.h)),
                                const Expanded(
                                  child: Skeletonizer(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        DetailTitleWidget(title: 'Artist name'),
                                        DetailDescriptionWidget(description: 'Artist Type'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Skeletonizer(child: DetailBioWidget(bio: 'Artist bio ' * 15)),
                            SizedBox(height: 30.h),
                            DetailSongListingWidget.loading(),
                            DetailAlbumListingWidget.loading(),
                            DetailLanguageListingWidget.loading(),
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
