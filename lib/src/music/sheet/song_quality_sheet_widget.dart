import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/theme/theme.dart';
import 'package:musicly/widgets/app_button.dart';

/// For display Song Quality Sheet Widget
class SongQualitySheetWidget extends StatefulWidget {
  /// Default constructor
  const SongQualitySheetWidget({super.key, this.onDownloadTap});

  ///
  final void Function(String quality)? onDownloadTap;

  @override
  State<SongQualitySheetWidget> createState() => _SongQualitySheetWidgetState();

  /// For show sheet
  static void show(
    BuildContext context, {
    void Function(String quality)? onDownloadTap,
  }) {
    showModalBottomSheet<dynamic>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.95,
      useRootNavigator: true,
      builder: (context) {
        return SongQualitySheetWidget(onDownloadTap: onDownloadTap);
      },
    );
  }
}

class _SongQualitySheetWidgetState extends State<SongQualitySheetWidget> {
  String selectedQuality = AppDB.settingManager.songQuality ?? '96kbps';
  late final List<SongQuality> qualities =
      widget.onDownloadTap != null ? downloadQualities : streamQualities;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: DecoratedBox(
        decoration: sheetDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Choose song quality',
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleLarge,
                ),
                SizedBox(height: 12.h),
                if (widget.onDownloadTap != null)
                  const Text(
                    'Select the quality for songs you download to listen offline. Higher quality takes up more storage space.',
                  )
                else
                  const Text(
                    'Choose the audio quality for streaming songs over the internet. Higher quality provides better sound but uses more data.',
                  ),
                SizedBox(height: 30.h),

                ...List.generate(qualities.length, (index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedQuality = qualities[index].quality;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.r),
                            border: Border.all(
                              color:
                                  selectedQuality == qualities[index].quality
                                      ? const Color(0xFF016BB8)
                                      : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  qualities[index].quality,
                                  style: context.textTheme.titleMedium,
                                ),
                                Text(
                                  qualities[index].message,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    height: 1,
                                    color: const Color(0xFF989CA0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  );
                }),
                SizedBox(height: 30.h),
                if (widget.onDownloadTap != null)
                  AppButton(
                    name: 'Download',
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onDownloadTap!.call(selectedQuality);
                    },
                  )
                else
                  AppButton(
                    name: 'Update',
                    onTap: () {
                      Navigator.of(context).pop();
                      AppDB.settingManager.songQuality = selectedQuality;
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

/// Song Quality Model
class SongQuality {
  /// Default constructor
  const SongQuality({required this.quality, required this.message});

  /// For display quality
  final String quality;

  /// For display message
  final String message;
}

/// List of Stream Qualities
const List<SongQuality> streamQualities = [
  SongQuality(
    quality: '12kbps',
    message:
        'Extreme data saver. Sound quality is significantly reduced. Best for very limited data.',
  ),
  SongQuality(
    quality: '48kbps',
    message: 'Lower quality. Good for limited mobile data.',
  ),
  SongQuality(
    quality: '96kbps',
    message: 'Balanced. Good for everyday listening.',
  ),
  SongQuality(
    quality: '160kbps',
    message:
        'Solid audio quality. Enjoy richer sound, but it will use more data.',
  ),
  SongQuality(
    quality: '320kbps',
    message:
        'Premium audio. Near-perfect sound quality, but it will use more data',
  ),
];

/// List of Download Qualities
const List<SongQuality> downloadQualities = [
  SongQuality(
    quality: '12kbps',
    message: 'Data saver and uses less storage space. Lowest quality.',
  ),
  SongQuality(
    quality: '48kbps',
    message: 'Good for limited mobile data or device storage. Low quality.',
  ),
  SongQuality(
    quality: '96kbps',
    message: 'Balanced. Good for everyday listening.',
  ),
  SongQuality(
    quality: '160kbps',
    message: 'Enjoy richer sound. Higher quality.',
  ),
  SongQuality(quality: '320kbps', message: 'Best quality. Premium audio.'),
];
