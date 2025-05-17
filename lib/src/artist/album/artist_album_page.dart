import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/db/data_base_handler.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/album/widgets/album_sheet_dialog_widget.dart';
import 'package:musicly/src/album/widgets/search_album_loading_widget.dart';
import 'package:musicly/src/artist/album/cubit/artist_album_cubit.dart';
import 'package:musicly/widgets/album_item_widget.dart';
import 'package:musicly/widgets/app_back_button.dart';

/// Artist Album Page
class ArtistAlbumPage extends StatelessWidget {
  /// Artist Album Page constructor
  const ArtistAlbumPage({required this.artistId, super.key});

  /// For get Artist Album list
  final String artistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistAlbumCubit(artistId: artistId),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [AppBackButton()]),
                Expanded(
                  child: BlocBuilder<ArtistAlbumCubit, ArtistAlbumState>(
                    buildWhen: (previous, current) => current.apiState != previous.apiState,
                    builder: (context, state) {
                      return switch (state.apiState) {
                        ApiState.idle || ApiState.loading => const SearchAlbumLoadingWidget(needPadding: false),
                        ApiState.success || ApiState.loadingMore => NotificationListener<UserScrollNotification>(
                          onNotification: context.read<ArtistAlbumCubit>().scrollListener,
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12.h,
                              crossAxisSpacing: 12.w,
                              childAspectRatio: 1 / 1.7,
                            ),
                            itemBuilder: (context, index) {
                              final album = state.albums[index];
                              return AlbumItemWidget(
                                albumImageURL: album.image?.last.url ?? '',
                                title: album.name ?? '',
                                description: album.description ?? '',
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
                        _ => const Center(child: Text('Error occurred while fetching albums.')),
                      };
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
