import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/src/search/model/artist/global_artist_model.dart';
import 'package:musicly/widgets/artist_item_widget.dart';

/// Artist Search Widget
class ArtistSearchWidget extends StatelessWidget {
  /// Artist Search Widget Constructor
  const ArtistSearchWidget({super.key, this.artists = const [], this.isFromLocalDatabase = false});

  /// List of artist
  final List<GlobalArtistModel> artists;

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
            Text('Artists', style: context.textTheme.titleMedium),
            if (artists.length >= 3 && !isFromLocalDatabase)
              Text('View All', style: context.textTheme.titleSmall?.copyWith(color: const Color(0xFF11A8FD))),
          ],
        ),
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
            final artist = artists[index];
            return ArtistItemWidget(
              artistImageURL: artist.image?.last.url ?? '',
              artistName: artist.title ?? '',
              onTap: () {
                if (!isFromLocalDatabase) {
                  context.read<SearchCubit>().onArtistItemTap(index);
                }
              },
            );
          },
          itemCount: artists.length,
        ),
      ],
    );
  }
}
