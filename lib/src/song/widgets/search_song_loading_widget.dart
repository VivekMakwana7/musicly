import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/widgets/song_item_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Search Song Loading Widget
class SearchSongLoadingWidget extends StatelessWidget {
  /// Search Song Loading Widget constructor
  const SearchSongLoadingWidget({super.key, this.needPadding = true});

  ///
  final bool needPadding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: needPadding ? 16.w : 0, vertical: 20.h),
      itemBuilder: (context, index) {
        return const Skeletonizer(
          child: SongItemWidget(
            description: 'song.description',
            songImageURL: 'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
            title: 'song.title',
            action: SizedBox.shrink(),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemCount: 9,
    );
  }
}
