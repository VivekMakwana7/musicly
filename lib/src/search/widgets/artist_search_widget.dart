import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/constants.dart';
import 'package:musicly/core/db/models/artist/db_artist_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/search/model/artist/global_artist_model.dart';
import 'package:musicly/widgets/artist_item_widget.dart';

/// Artist Search Widget
class ArtistSearchWidget extends StatelessWidget {
  /// Artist Search Widget Constructor
  const ArtistSearchWidget({super.key, this.globalArtists, this.dbArtists, this.query});

  /// Artist Search Widget Constructor from API
  factory ArtistSearchWidget.api({required List<GlobalArtistModel> artists, String? query}) {
    return ArtistSearchWidget(globalArtists: artists, query: query);
  }

  /// Artist Search Widget Constructor from Database
  factory ArtistSearchWidget.fromDatabase(List<DbArtistModel> artists) {
    return ArtistSearchWidget(dbArtists: artists);
  }

  /// List of artist
  final List<GlobalArtistModel>? globalArtists;

  /// List of artist from the local database to display in the search widget
  final List<DbArtistModel>? dbArtists;

  /// The search query used to find these artist (if applicable).
  final String? query;

  @override
  Widget build(BuildContext context) {
    final artists = globalArtists ?? dbArtists ?? [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Artists', style: context.textTheme.titleMedium),
            if (artists.length >= minArtistForViewAll)
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.searchArtistPage, extra: {'query': query}),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                child: Text('View All', style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD))),
              ),
          ],
        ),
        if (globalArtists != null)
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
              final artist = globalArtists![index];
              return ArtistItemWidget(
                artistImageURL: artist.image?.last.url ?? '',
                artistName: artist.title ?? '',
                onTap: () {
                  context.pushNamed(AppRoutes.artistDetailPage, extra: {'artistId': artist.id});
                },
              );
            },
            itemCount: globalArtists!.length,
          ),
        if (dbArtists != null)
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
              final artist = dbArtists![index];
              return ArtistItemWidget(
                artistImageURL: artist.image?.last.url ?? '',
                artistName: artist.name ?? '',
                onTap: () {
                  context.pushNamed(AppRoutes.artistDetailPage, extra: {'artistId': artist.id});
                },
              );
            },
            itemCount: dbArtists!.take(minDbArtistCountForDisplay).length,
          ),
      ],
    );
  }
}
