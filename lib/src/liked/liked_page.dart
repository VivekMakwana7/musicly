import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/cubits/audio/audio_cubit.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/source_handler/source_type.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/liked/cubit/like_cubit.dart';
import 'package:musicly/widgets/detail_album_listing_widget.dart';
import 'package:musicly/widgets/detail_song_listing_widget.dart';
import 'package:musicly/widgets/song_item_widget.dart';

/// Liked Page
class LikedPage extends StatelessWidget {
  /// Liked Page constructor
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikeCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(greeting)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocBuilder<LikeCubit, LikeState>(
            builder: (context, state) {
              final cubit = context.read<LikeCubit>();

              return ValueListenableBuilder(
                valueListenable: cubit.isLikedEmpty,
                builder: (context, _, _) {
                  if (cubit.isLikedEmpty.value) {
                    return Center(
                      child: Text(
                        'No liked songs yet. Tap the heart icon next to a song to add it to your favorites!',
                        style: context.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView(
                    children: [
                      SizedBox(height: 20.h),
                      StreamBuilder(
                        stream: cubit.likedSongStream,
                        builder: (context, snapshot) {
                          final list = AppDB.likedManager.likedSongs;

                          if (list.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return DetailSongListingWidget(
                            songs: list,
                            onTap: (index) {
                              Injector.instance<AppCubit>().resetState();
                              Injector.instance<AudioCubit>().loadSourceData(
                                type: SourceType.liked,
                                songId: list[index].id,
                                page: 0,
                                isPaginated: false,
                                songs: list,
                              );
                            },
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: cubit.likedAlbumStream,
                        builder: (context, snapshot) {
                          final list = AppDB.likedManager.likedAlbums;

                          if (list.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return DetailAlbumListingWidget(albums: list, title: 'Liked Albums');
                        },
                      ),

                      StreamBuilder(
                        stream: cubit.likedPlaylistStream,
                        builder: (context, snapshot) {
                          final list = AppDB.likedManager.likedPlaylists;

                          if (list.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 20.h),
                              const Text('Liked Playlist'),
                              Flexible(
                                child: ListView.separated(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final playlist = list[index];
                                    return SongItemWidget(
                                      description: playlist.description ?? '',
                                      songImageURL: playlist.image?.first.url ?? '',
                                      title: playlist.name ?? '',
                                      onTap: () {
                                        context.pushNamed(
                                          AppRoutes.playlistDetailPage,
                                          extra: {'playlistId': playlist.id},
                                        );
                                      },
                                      action: const SizedBox.shrink(),
                                    );
                                  },
                                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                                  itemCount: list.length,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// Returns an appropriate greeting based on the current hour of the day
  String get greeting {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 5) {
      return 'Good Night';
    } else if (hour < 12) {
      return 'Good Morning';
    } else if (hour == 12) {
      return 'Good Noon';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
}
