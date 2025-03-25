import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/src/playlist/cubit/search_playlist_cubit.dart';
import 'package:musicly/src/song/widgets/search_song_loading_widget.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Search Playlist page
class SearchPlaylistPage extends StatelessWidget {
  /// Search Playlist Page Constructor
  const SearchPlaylistPage({super.key, this.query});

  /// For search Playlist
  final String? query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchPlaylistCubit(query: query),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search playlists')),
        body: BlocBuilder<SearchPlaylistCubit, SearchPlaylistState>(
          buildWhen: (previous, current) => current.apiState != previous.apiState,
          builder: (context, state) {
            return switch (state.apiState) {
              ApiState.idle || ApiState.loading => const SearchSongLoadingWidget(),
              ApiState.success || ApiState.loadingMore => NotificationListener<UserScrollNotification>(
                onNotification: context.read<SearchPlaylistCubit>().scrollListener,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  itemBuilder: (context, index) {
                    final playlist = state.playlists[index];
                    return SongItemWidget(
                      description: playlist.description ?? '',
                      songImageURL: playlist.image?.first.url ?? '',
                      title: playlist.name ?? '',
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemCount: state.playlists.length,
                ),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
