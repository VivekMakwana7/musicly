import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/artist/artist_detail/cubit/artist_detail_cubit.dart';
import 'package:musicly/widgets/album_item_widget.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/network_image_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// For display Artist Detail page
class ArtistDetailPage extends StatelessWidget {
  /// Artist Detail Page constructor
  const ArtistDetailPage({required this.artistId, super.key});

  /// For get Artist detail
  final String artistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistDetailCubit(artistId: artistId),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppBackButton(),
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
                BlocBuilder<ArtistDetailCubit, ArtistDetailState>(
                  buildWhen: (previous, current) => current.apiState != previous.apiState,
                  builder: (context, state) {
                    final artist = state.artist;
                    return switch (state.apiState) {
                      ApiState.success => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            Row(
                              spacing: 12.w,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(26.r),
                                  child: NetworkImageWidget(
                                    url: artist?.image?.last.url ?? '',
                                    height: 70.h,
                                    width: 70.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(artist?.name ?? '', style: context.textTheme.titleLarge),
                                      Text(
                                        artist?.dominantType ?? '',
                                        style: context.textTheme.titleSmall?.copyWith(
                                          height: 1,
                                          color: const Color(0xFF989CA0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              artist?.bio?.first.text ?? '',
                              style: context.textTheme.titleSmall?.copyWith(
                                height: 1.1,
                                color: const Color(0xFF989CA0),
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            if (artist?.topSongs != null) ...[
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
                                      const Text('Top Songs'),
                                      SizedBox(height: 12.h),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final albumSong = artist.topSongs![index];
                                          return GestureDetector(
                                            onTap: () {
                                              Injector.instance<AudioCubit>().setLocalSource(
                                                song: albumSong,
                                                source: artist.topSongs ?? [],
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
                                                        '${albumSong.label}',
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
                                        itemCount: artist!.topSongs!.length,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            if (artist?.topAlbums != null) ...[
                              SizedBox(height: 30.h),
                              const Text('Top Albums'),
                              SizedBox(height: 12.h),
                              SizedBox(
                                height: 162.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final album = artist.topAlbums![index];
                                    return SizedBox(
                                      width: 104.w,
                                      child: AlbumItemWidget(
                                        albumImageURL: album.image?.last.url ?? '',
                                        title: album.name ?? '',
                                        description: album.description ?? '',
                                        onTap: () {
                                          context.pushNamed(AppRoutes.albumDetailPage, extra: {'albumId': album.id});
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                                  itemCount: artist!.topAlbums!.length,
                                ),
                              ),
                            ],

                            SizedBox(height: 30.h),
                            const Text('Languages'),
                            SizedBox(height: 12.h),
                            Wrap(
                              runSpacing: 6.h,
                              spacing: 8.w,
                              children: List.generate(
                                artist?.availableLanguages?.length ?? 0,
                                (index) => DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF282C30),
                                    borderRadius: BorderRadius.circular(26.r),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                    child: Text(artist?.availableLanguages![index] ?? ''),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                      ApiState.loading || ApiState.idle => Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 30.h),
                            Row(
                              spacing: 12.w,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(26.r),
                                  child: Skeletonizer(
                                    child: NetworkImageWidget(
                                      url: 'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
                                      height: 70.h,
                                      width: 70.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Skeletonizer(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text('Artist Name', style: context.textTheme.titleLarge),
                                        Text(
                                          'Artist type',
                                          style: context.textTheme.titleSmall?.copyWith(
                                            height: 1,
                                            color: const Color(0xFF989CA0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Skeletonizer(
                              child: Text(
                                'Artist bio ' * 15,
                                style: context.textTheme.titleSmall?.copyWith(
                                  height: 1.1,
                                  color: const Color(0xFF989CA0),
                                  fontStyle: FontStyle.italic,
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
                                    const Skeletonizer(child: Text('Top Songs')),
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
                                                        'Song Name',
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: context.textTheme.bodyMedium,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Song description',
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
                                      itemCount: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            const Skeletonizer(child: Text('Top Albums')),
                            SizedBox(height: 12.h),
                            SizedBox(
                              height: 162.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Skeletonizer(
                                    child: SizedBox(
                                      width: 104.w,
                                      child: const AlbumItemWidget(
                                        albumImageURL:
                                            'https://c.saavncdn.com/editorial/DoodhchPatti_20250311120650_500x500.jpg',
                                        title: 'Album name',
                                        description: 'Album',
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                                itemCount: 5,
                              ),
                            ),

                            SizedBox(height: 30.h),
                            const Skeletonizer(child: Text('Languages')),
                            SizedBox(height: 12.h),
                            Wrap(
                              runSpacing: 6.h,
                              spacing: 8.w,
                              children: List.generate(
                                5,
                                (index) => Skeletonizer(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF282C30),
                                      borderRadius: BorderRadius.circular(26.r),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                      child: Text('Language : $index'),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                      _ => const SizedBox(),
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
