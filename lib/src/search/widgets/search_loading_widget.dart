import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/widgets/album_item_widget.dart';
import 'package:musicly/widgets/artist_item_widget.dart';
import 'package:musicly/widgets/song_item_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Search Loading Widget
class SearchLoadingWidget extends StatelessWidget {
  /// Search Loading Widget constructor
  const SearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12.h,
            children: [
              Text('Songs', style: context.textTheme.titleMedium),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return const Skeletonizer(
                      child: SongItemWidget(
                        description: 'song.description',
                        songImageURL: 'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
                        title: 'song.title',
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemCount: 3,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12.h,
            children: [
              Text('Album', style: context.textTheme.titleMedium),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 1 / 1.7,
                  ),
                  itemBuilder: (context, index) {
                    return const Skeletonizer(
                      child: AlbumItemWidget(
                        description: 'song.description',
                        albumImageURL: 'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
                        title: 'song.title',
                      ),
                    );
                  },
                  itemCount: 3,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12.h,
            children: [
              Text('Artist', style: context.textTheme.titleMedium),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: context.width / 2,
                    mainAxisExtent: 56.h,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                  ),
                  itemBuilder: (context, index) {
                    return const Skeletonizer(
                      child: ArtistItemWidget(
                        artistImageURL: 'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
                        artistName: 'artist.title',
                      ),
                    );
                  },
                  itemCount: 4,
                ),
              ),
            ],
          ),
          // ArtistSearchWidget(artists: appDb.artistSearchHistory, isFromLocalDatabase: true),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
