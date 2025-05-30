import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/album/cubit/search_album_cubit.dart';
import 'package:musicly/src/album/widgets/album_sheet_dialog_widget.dart';
import 'package:musicly/src/album/widgets/search_album_loading_widget.dart';
import 'package:musicly/widgets/album_item_widget.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';

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
                      albumImageURL: album.image?.last.url ?? '',
                      title: album.name ?? '',
                      onTap: () {
                        context.pushNamed(AppRoutes.albumDetailPage, extra: {'albumId': album.id});
                      },
                      onMoreTap: () async {
                        final resAlbum = await DatabaseHandler.getAlbumById(album.id);
                        if (resAlbum == null) return;
                        if (context.mounted) AlbumSheetDialogWidget.show(context, album: resAlbum);
                      },
                    );
                  },
                  itemCount: state.albums.length,
                ),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
        bottomNavigationBar: const AudioWidget(),
      ),
    );
  }
}
