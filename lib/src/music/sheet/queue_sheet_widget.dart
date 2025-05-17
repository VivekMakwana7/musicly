import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Queue Sheet Widget
class QueueSheetWidget extends StatelessWidget {
  /// Default constructor
  const QueueSheetWidget({super.key, this.song});

  /// For add given song to queue
  final DbSongModel? song;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: DecoratedBox(
        decoration: sheetDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                spacing: 12.w,
                children: [
                  SizedBox.square(
                    dimension: 50.h,
                    child: ClipOval(child: NetworkImageWidget(url: song?.image?.last.url ?? '')),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Text(
                            (song?.name ?? '').formatSongTitle,
                            maxLines: (song?.label ?? '').isNotEmpty ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        if ((song?.label ?? '').isNotEmpty)
                          Text(
                            song?.label ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
