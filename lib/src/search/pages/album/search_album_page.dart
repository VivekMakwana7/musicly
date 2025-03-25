import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/src/search/pages/album/cubit/search_album_cubit.dart';
import 'package:musicly/src/search/pages/album/widgets/search_album_loading_widget.dart';
import 'package:musicly/widgets/album_item_widget.dart';

/// Search Song Page
class SearchAlbumPage extends StatelessWidget {
  /// Search Song Page constructor
  const SearchAlbumPage({super.key, this.query});

  /// For search albums
  final String? query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchAlbumCubit(query: query),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search albums')),
        body: BlocBuilder<SearchAlbumCubit, SearchAlbumState>(
          buildWhen: (previous, current) => current.apiState != previous.apiState,
          builder: (context, state) {
            return switch (state.apiState) {
              ApiState.idle || ApiState.loading => const SearchAlbumLoadingWidget(),
              ApiState.success || ApiState.loadingMore => NotificationListener<UserScrollNotification>(
                onNotification: context.read<SearchAlbumCubit>().scrollListener,
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 1 / 1.7,
                  ),
                  itemBuilder: (context, index) {
                    final album = state.albums[index];
                    return AlbumItemWidget(
                      description: album.description ?? '',
                      albumImageURL: album.image?.first.url ?? '',
                      title: album.name ?? '',
                    );
                  },
                  itemCount: state.albums.length,
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
