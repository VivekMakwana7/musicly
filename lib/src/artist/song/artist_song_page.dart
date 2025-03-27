import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/src/artist/song/cubit/artist_song_cubit.dart';
import 'package:musicly/src/song/widgets/search_song_loading_widget.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/app_more_button.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Artist Song Page
class ArtistSongPage extends StatelessWidget {
  /// Artist Song Page constructor
  const ArtistSongPage({required this.artistId, super.key});

  /// For get Artist Song  list
  final String artistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistSongCubit(artistId: artistId),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [AppBackButton(), AppMoreButton()],
              ),
              Expanded(
                child: BlocBuilder<ArtistSongCubit, ArtistSongState>(
                  buildWhen: (previous, current) => current.apiState != previous.apiState,
                  builder: (context, state) {
                    return switch (state.apiState) {
                      ApiState.idle || ApiState.loading => const SearchSongLoadingWidget(),
                      ApiState.success || ApiState.loadingMore => NotificationListener<UserScrollNotification>(
                        onNotification: context.read<ArtistSongCubit>().scrollListener,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                          itemBuilder: (context, index) {
                            final song = state.songs[index];
                            return SongItemWidget(
                              description: song.label ?? '',
                              songImageURL: song.image?.last.url ?? '',
                              title: song.name ?? '',
                              onTap: () {
                                // Injector.instance<AudioCubit>().setNetworkSource(
                                //   type: SourceType.searchArtistSong,
                                //   query: '',
                                //   songId: song.id,
                                //   page: context.read<ArtistSongCubit>().page,
                                //   sources: state.songs,
                                //   artistId: artistId,
                                // );
                              },
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(height: 16.h),
                          itemCount: state.songs.length,
                        ),
                      ),
                      _ => const SizedBox.shrink(),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AudioWidget(),
      ),
    );
  }
}
