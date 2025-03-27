import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/src/library/cubit/library_cubit.dart';
import 'package:musicly/widgets/app_button.dart';
import 'package:musicly/widgets/app_text_field.dart';
import 'package:musicly/widgets/artist_item_widget.dart';
import 'package:musicly/widgets/detail_title_widget.dart';

/// Library Page
class LibraryPage extends StatelessWidget {
  /// Library Page Constructor
  const LibraryPage({super.key, this.song});

  /// For add Song in Playlist
  final DbSongModel? song;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(greeting)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocBuilder<LibraryCubit, LibraryState>(
            builder: (context, state) {
              final cubit = context.read<LibraryCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    spacing: 12.w,
                    children: [
                      Expanded(
                        flex: 8,
                        child: AppTextField(hintText: 'New Playlist', controller: cubit.playlistController),
                      ),
                      Expanded(flex: 3, child: AppButton(name: 'New', onTap: cubit.onNewTap)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  const DetailTitleWidget(title: 'Playlists'),
                  SizedBox(height: 18.h),
                  Expanded(
                    child: StreamBuilder(
                      stream: cubit.playlistStream,
                      builder: (context, _) {
                        final list = Injector.instance<AppDB>().songPlaylist;
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            final playlist = list[index];
                            return SizedBox(
                              height: 54.h,
                              child: ArtistItemWidget(
                                artistImageURL: playlist.image,
                                artistName: playlist.name,
                                action: IconButton(
                                  onPressed: () => cubit.onPlaylistRemoveTap(index),
                                  icon: const Icon(Icons.cancel_outlined),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(height: 12.h),
                          itemCount: list.length,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
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
