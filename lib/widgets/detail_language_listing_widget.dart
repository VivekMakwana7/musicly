import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// for display Language listing
class DetailLanguageListingWidget extends StatelessWidget {
  /// Language listing constructor
  const DetailLanguageListingWidget({required this.languages, super.key});

  /// factory constructor for loading
  factory DetailLanguageListingWidget.loading() => const DetailLanguageListingWidget(languages: []);

  /// List of Languages
  final List<String?> languages;

  @override
  Widget build(BuildContext context) {
    final isLoading = languages.isEmpty;
    final list = languages.toList()..removeWhere((element) => element == 'unknown');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30.h),
        Skeletonizer(enabled: isLoading, child: const Text('Languages')),
        SizedBox(height: 12.h),
        Wrap(
          runSpacing: 6.h,
          spacing: 8.w,
          children: List.generate(
            isLoading ? 6 : list.length,
            (index) => Skeletonizer(
              enabled: isLoading,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF282C30),
                  borderRadius: BorderRadius.circular(26.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  child: Text(isLoading ? 'Language $index' : list[index]?.toCapitalised ?? ''),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
