import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/cubits/app/app_cubit.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/app_more_button.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/detail_image_view.dart';
import 'package:musicly/widgets/detail_song_listing_widget.dart';

/// Library Detail Page
class LibraryDetailPage extends StatelessWidget {
  /// Library Detail Page Constructor
  const LibraryDetailPage({required this.libraryId, super.key});

  /// Current Library
  final String libraryId;

  @override
  Widget build(BuildContext context) {
    final library = Injector.instance<AppDB>().songPlaylist.firstWhere((element) => element.id == libraryId);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 12.h),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [AppBackButton(), AppMoreButton()],
              ),
              SizedBox(height: 20.h),
              DetailImageView(imageUrl: library.image),
              SizedBox(height: 20.h),
              Text(library.name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              SizedBox(height: 20.h),
              DetailSongListingWidget(
                songs: library.songs,
                onTap: (index) {
                  Injector.instance<AppCubit>().librarySongPlayed(libraryId);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AudioWidget(),
    );
  }
}
