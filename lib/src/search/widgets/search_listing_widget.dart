import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/src/search/cubit/search_cubit.dart';
import 'package:musicly/src/search/widgets/search_api_listing_widget.dart';
import 'package:musicly/src/search/widgets/search_data_base_listing_widget.dart';
import 'package:musicly/src/search/widgets/search_loading_widget.dart';

/// Search listing widget
class SearchListingWidget extends StatelessWidget {
  /// Search listing widget constructor
  const SearchListingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<SearchCubit>().searchController,
      builder: (context, _, _) {
        if (context.read<SearchCubit>().searchController.text.isEmpty) {
          return const SearchDataBaseListingWidget();
        }

        return BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (previous, current) => current.apiState != previous.apiState,
          builder: (context, state) {
            return switch (state.apiState) {
              ApiState.loading => const SearchLoadingWidget(),
              ApiState.success => const SearchApiListingWidget(),
              _ => const SizedBox.shrink(),
            };
          },
        );
      },
    );
  }
}
