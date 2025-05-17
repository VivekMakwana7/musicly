import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/src/music/sheet/song_quality_sheet_widget.dart';
import 'package:musicly/widgets/app_animated_switcher.dart';
import 'package:musicly/widgets/app_back_button.dart';
import 'package:musicly/widgets/app_button.dart';
import 'package:musicly/widgets/bottom_nav/audio_widget.dart';
import 'package:musicly/widgets/detail_description_widget.dart';
import 'package:musicly/widgets/detail_title_widget.dart';

/// Setting Page
class SettingPage extends StatelessWidget {
  /// Setting page's constructor
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20.h,
            children: [
              const Row(children: [AppBackButton()]),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1F22),
                  borderRadius: BorderRadius.circular(26.r),
                  border: const Border(top: BorderSide(color: Color(0xFF424750), width: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF262E32).withValues(alpha: 0.7),
                      blurRadius: 20,
                      offset: const Offset(-3, -3),
                    ),
                    BoxShadow(
                      color: const Color(0xFF101012).withValues(alpha: 0.75),
                      blurRadius: 20,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8.h,
                    children: [
                      const DetailTitleWidget(title: 'Audio Quality'),
                      const DetailDescriptionWidget(description: 'Chane your audio quality for better performance'),
                      SizedBox(height: 8.h),
                      AppButton(
                        name: 'Change Quality',
                        onTap: () {
                          SongQualitySheetWidget.show(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1F22),
                  borderRadius: BorderRadius.circular(26.r),
                  border: const Border(top: BorderSide(color: Color(0xFF424750), width: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF262E32).withValues(alpha: 0.7),
                      blurRadius: 20,
                      offset: const Offset(-3, -3),
                    ),
                    BoxShadow(
                      color: const Color(0xFF101012).withValues(alpha: 0.75),
                      blurRadius: 20,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 8.h,
                          children: const [
                            DetailTitleWidget(title: 'Gapless'),
                            DetailDescriptionWidget(description: 'Allows gapless playback'),
                          ],
                        ),
                      ),
                      AppAnimatedSwitcher(
                        value: AppDB.settingManager.gapLess,
                        onChanged: (value) {
                          AppDB.settingManager.gapLess = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AudioWidget(),
    );
  }
}
