import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/src/search/model/album/global_album_model.dart';
import 'package:musicly/widgets/album_item_widget.dart';

/// Album Search Widget
class AlbumSearchWidget extends StatelessWidget {
  /// Album Search Widget Constructor
  const AlbumSearchWidget({super.key, this.albums = const [], this.isFromLocalDatabase = false});

  /// List of album results to display in the search widget
  final List<GlobalAlbumModel> albums;

  /// Hide View all option for DB data
  final bool isFromLocalDatabase;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Albums', style: context.textTheme.titleMedium),
            if (albums.length >= 3 && !isFromLocalDatabase)
              Text('View All', style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD))),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1 / 1.7,
          ),
          itemBuilder: (context, index) {
            final album = albums[index];
            return AlbumItemWidget(
              albumImageURL: album.image?.last.url ?? '',
              title: album.title ?? '',
              description: album.description ?? '',
              onTap: () {
                if (!isFromLocalDatabase) {
                  context.read<SearchCubit>().onAlbumItemTap(index);
                }
              },
            );
          },
          itemCount: albums.length,
        ),
      ],
    );
  }
}
