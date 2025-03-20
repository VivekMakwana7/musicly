import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/src/search/model/album/global_album_model.dart';
import 'package:musicly/src/search/model/artist/global_artist_model.dart';
import 'package:musicly/src/search/model/song/global_song_model.dart';
import 'package:musicly/src/search/model/top_trending/global_top_trending_model.dart';
import 'package:musicly/src/search/widgets/album_search_widget.dart';
import 'package:musicly/src/search/widgets/artist_search_widget.dart';
import 'package:musicly/src/search/widgets/song_search_widget.dart';
import 'package:musicly/src/search/widgets/top_trending_search_widget.dart';

/// Search api listing widget
class SearchApiListingWidget extends StatelessWidget {
  /// Search api listing widget constructor
  const SearchApiListingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          BlocSelector<SearchCubit, SearchState, List<GlobalTopTrendingModel>>(
            selector: (state) => state.searchModel?.topTrending ?? [],
            builder: (context, topTrending) {
              if (topTrending.isNotEmpty) {
                return TopTrendingSearchWidget(topTrendingList: topTrending);
              }

              return const SizedBox.shrink();
            },
          ),
          SizedBox(height: 20.h),
          BlocSelector<SearchCubit, SearchState, List<GlobalSongModel>>(
            selector: (state) => state.searchModel?.songs ?? [],
            builder: (context, songs) {
              if (songs.isNotEmpty) {
                return SongSearchWidget(songs: songs, query: context.read<SearchCubit>().searchController.text.trim());
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(height: 20.h),
          BlocSelector<SearchCubit, SearchState, List<GlobalAlbumModel>>(
            selector: (state) => state.searchModel?.albums ?? [],
            builder: (context, albums) {
              if (albums.isNotEmpty) {
                return AlbumSearchWidget(albums: albums);
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(height: 20.h),
          BlocSelector<SearchCubit, SearchState, List<GlobalArtistModel>>(
            selector: (state) => state.searchModel?.artists ?? [],
            builder: (context, artists) {
              if (artists.isNotEmpty) {
                return ArtistSearchWidget(artists: artists);
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
