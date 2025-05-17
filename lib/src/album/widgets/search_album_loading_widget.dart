import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/widgets/album_item_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Search Album Loading Widget
class SearchAlbumLoadingWidget extends StatelessWidget {
  /// Search Album Loading Widget constructor
  const SearchAlbumLoadingWidget({super.key, this.needPadding = true});

  ///
  final bool needPadding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: needPadding ? 16.w : 0, vertical: 20.h),
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
      itemCount: 9,
    );
  }
}
