import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/album/album_detail/cubit/album_detail_cubit.dart';
import 'package:musicly/widgets/artist_item_widget.dart';
import 'package:musicly/widgets/network_image_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// For display Album Detail page
class AlbumDetailPage extends StatelessWidget {
  /// Album Detail Page constructor
  const AlbumDetailPage({required this.albumId, super.key});

  /// For get album detail
  final String albumId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumDetailCubit(albumId: albumId),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2F353A), Color(0xFF1C1F22)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: SizedBox.square(dimension: 40.h, child: Center(child: Assets.icons.icMore.svg())),
                    ),
                  ],
                ),
                BlocBuilder<AlbumDetailCubit, AlbumDetailState>(
                  buildWhen: (previous, current) => current.apiState != previous.apiState,
                  builder: (context, state) {
                    return switch (state.apiState) {
                      ApiState.success => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26.r),
                                child: NetworkImageWidget(
                                  url: state.album?.image?.last.url ?? '',
                                  width: 160.h,
                                  height: 160.h,
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Text(state.album?.name ?? '', style: context.textTheme.titleLarge),
                            SizedBox(height: 6.h),
                            Text(
                              state.album?.description ?? '',
                              style: context.textTheme.titleSmall?.copyWith(height: 1, color: const Color(0xFF989CA0)),
                            ),
                            SizedBox(height: 30.h),
                            if (state.album!.songs != null)
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF282C30),
                                  borderRadius: BorderRadius.circular(26.r),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.h),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Songs',
                                        style: context.textTheme.titleSmall?.copyWith(fontWeight: semiBoldFontWeight),
                                      ),
                                      SizedBox(height: 12.h),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final albumSong = state.album!.songs![index];
                                          return GestureDetector(
                                            onTap: () {
                                              Injector.instance<AudioCubit>().setLocalSource(
                                                song: albumSong,
                                                source: state.album?.songs ?? [],
                                              );
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Row(
                                              spacing: 12.w,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12.r),
                                                  child: NetworkImageWidget(
                                                    url: albumSong.image?.last.url ?? '',
                                                    height: 52.h,
                                                    width: 52.h,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    spacing: 4.h,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          albumSong.name ?? '',
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: context.textTheme.bodyMedium,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${albumSong.label} | ${albumSong.artists?.primary?.first.name ?? ''}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: context.textTheme.bodySmall?.copyWith(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) => SizedBox(height: 10.h),
                                        itemCount: state.album!.songs!.length,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 30.h),
                            Text(
                              'Artists',
                              style: context.textTheme.titleSmall?.copyWith(fontWeight: semiBoldFontWeight),
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
                                final artist = state.album?.artists?.primary![index];
                                return ArtistItemWidget(
                                  artistImageURL: artist?.image?.last.url ?? '',
                                  artistName: artist?.name ?? '',
                                );
                              },
                              itemCount: state.album?.artists?.primary?.length,
                            ),
                          ],
                        ),
                      ),
                      ApiState.loading || ApiState.idle => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26.r),
                                child: Skeletonizer(
                                  child: NetworkImageWidget(
                                    url: 'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
                                    width: 160.h,
                                    height: 160.h,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Skeletonizer(child: Text('Album name', style: context.textTheme.titleLarge)),
                            SizedBox(height: 6.h),
                            Skeletonizer(
                              child: Text(
                                'Album description',
                                style: context.textTheme.titleSmall?.copyWith(
                                  height: 1,
                                  color: const Color(0xFF989CA0),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0xFF282C30),
                                borderRadius: BorderRadius.circular(26.r),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Songs',
                                      style: context.textTheme.titleSmall?.copyWith(fontWeight: semiBoldFontWeight),
                                    ),
                                    SizedBox(height: 12.h),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Skeletonizer(
                                          child: Row(
                                            spacing: 12.w,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12.r),
                                                child: NetworkImageWidget(
                                                  url:
                                                      'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
                                                  height: 52.h,
                                                  width: 52.h,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  spacing: 4.h,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        'Album song name',
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: context.textTheme.bodyMedium,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Album description',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                                      itemCount: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              'Artists',
                              style: context.textTheme.titleSmall?.copyWith(fontWeight: semiBoldFontWeight),
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
                                return const Skeletonizer(
                                  child: ArtistItemWidget(
                                    artistImageURL:
                                        'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
                                    artistName: 'Artist name',
                                  ),
                                );
                              },
                              itemCount: 2,
                            ),
                          ],
                        ),
                      ),
                      _ => const SizedBox.shrink(),
                    };
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
