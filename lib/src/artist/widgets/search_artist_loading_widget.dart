import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/widgets/artist_item_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Search Artist Loading Widget
class SearchArtistLoadingWidget extends StatelessWidget {
  /// Search Artist Loading Widget Constructor
  const SearchArtistLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
      itemCount: 12,
    );
  }
}
