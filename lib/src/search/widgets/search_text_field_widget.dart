import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/widgets/app_text_field.dart';

/// Search TextField Widget
class SearchTextFieldWidget extends StatelessWidget {
  /// Search TextField Widget Constructor
  const SearchTextFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return ValueListenableBuilder(
      valueListenable: cubit.searchController,
      builder: (context, _, _) {
        return IntrinsicHeight(
          child: Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: AppTextField(
                  prefixIcon: Assets.icons.icSearch.svg(
                    height: 16.h,
                    width: 16.h,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  controller: cubit.searchController,
                  hintText: 'what do you want to listen to?',
                ),
              ),
              if (cubit.searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: cubit.onClearFieldTap,
                  behavior: HitTestBehavior.opaque,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2F353A), Color(0xFF1C1F22)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const Center(child: Icon(Icons.cancel_outlined)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
