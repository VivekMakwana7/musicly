import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/search_item_type.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/src/search/model/top_trending/global_top_trending_model.dart';
import 'package:musicly/widgets/album_item_widget.dart';
import 'package:musicly/widgets/artist_item_widget.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Top Trending Search Widget
class TopTrendingSearchWidget extends StatelessWidget {
  /// Top Trending Search Widget Constructor
  const TopTrendingSearchWidget({super.key, this.topTrendingList = const []});

  /// Top Trending List
  final List<GlobalTopTrendingModel> topTrendingList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        Text('Top', style: context.textTheme.titleMedium),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final topTrending = topTrendingList[index];
              return switch (topTrending.type) {
                SearchItemType.artist => Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 56.h,
                    width: context.width * 0.5 - 32.w,
                    child: ArtistItemWidget(
                      artistImageURL: topTrending.image?.last.url ?? '',
                      artistName: topTrending.title ?? '',
                      onTap: () {
                        context.pushNamed(AppRoutes.artistDetailPage, extra: {'artistId': topTrending.id});
                      },
                    ),
                  ),
                ),
                SearchItemType.album => Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 168.h,
                    width: 98.w,
                    child: AlbumItemWidget(
                      title: topTrending.title ?? '',
                      albumImageURL: topTrending.image?.last.url ?? '',
                      description: topTrending.description ?? '',
                      onTap: () {
                        context.pushNamed(AppRoutes.albumDetailPage, extra: {'albumId': topTrending.id});
                      },
                    ),
                  ),
                ),
                _ => SongItemWidget(
                  description: topTrending.description ?? '',
                  songImageURL: topTrending.image?.last.url ?? '',
                  title: topTrending.title ?? '',
                  onTap: () {
                    Injector.instance<AudioCubit>().setNetworkSource(
                      type: SourceType.searchSong,
                      query: context.read<SearchCubit>().searchController.text.trim(),
                      page: 1,
                      songId: topTrending.id,
                    );
                  },
                ),
              };
            },
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemCount: topTrendingList.length,
          ),
        ),
      ],
    );
  }
}
