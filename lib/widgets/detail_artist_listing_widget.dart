import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/widgets/artist_item_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// For display Detail page's Artist listing
class DetailArtistListingWidget extends StatelessWidget {
  /// Detail Artist Listing Widget constructor
  const DetailArtistListingWidget({required this.artists, super.key});

  /// For display Skeletonized widget
  factory DetailArtistListingWidget.loading() => const DetailArtistListingWidget(artists: []);

  /// List of Artists
  final List<DbSongPrimaryArtist> artists;

  @override
  Widget build(BuildContext context) {
    final isLoading = artists.isEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Skeletonizer(
          enabled: isLoading,
          child: Text('Artists', style: context.textTheme.titleSmall?.copyWith(fontWeight: semiBoldFontWeight)),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: context.width / 2,
            mainAxisExtent: 56.h,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
          ),
          itemBuilder: (context, index) {
            final image = isLoading ? imageUrl : artists[index].image?.last.url ?? '';
            final name = isLoading ? 'Artist name' : artists[index].name ?? '';

            return Skeletonizer(
              enabled: isLoading,
              child: ArtistItemWidget(
                artistImageURL: image,
                artistName: name,
                onTap: () {
                  if (!isLoading) context.pushNamed(AppRoutes.artistDetailPage, extra: {'artistId': artists[index].id});
                },
              ),
            );
          },
          itemCount: artists.isEmpty ? 4 : artists.length,
        ),
      ],
    );
  }
}
