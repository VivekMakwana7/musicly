import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/src/search/widgets/search_listing_widget.dart';
import 'package:musicly/src/search/widgets/search_text_field_widget.dart';

/// Search Page
class SearchPage extends StatelessWidget {
  /// Search page constructor
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 20.h,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: const SearchTextFieldWidget()),
            const SearchListingWidget(),
          ],
        ),
      ),
    );
  }
}
