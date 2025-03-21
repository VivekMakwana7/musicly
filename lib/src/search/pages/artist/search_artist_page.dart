import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/enums/api_state.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/src/search/pages/artist/cubit/search_artist_cubit.dart';
import 'package:musicly/src/search/pages/artist/widgets/search_artist_loading_widget.dart';
import 'package:musicly/widgets/artist_item_widget.dart';

/// Search Artist Page
class SearchArtistPage extends StatelessWidget {
  /// Search Artist Page Constructor
  const SearchArtistPage({super.key, this.query});

  /// The search query used to find these artist (if applicable).
  final String? query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchArtistCubit(query: query),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search Artist')),
        body: BlocBuilder<SearchArtistCubit, SearchArtistState>(
          buildWhen: (previous, current) => current.apiState != previous.apiState,
          builder: (context, state) {
            return switch (state.apiState) {
              ApiState.idle || ApiState.loading => const SearchArtistLoadingWidget(),
              ApiState.success || ApiState.loadingMore => NotificationListener<UserScrollNotification>(
                onNotification: context.read<SearchArtistCubit>().scrollListener,
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: context.width / 2,
                    mainAxisExtent: 56.h,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                  ),
                  itemBuilder: (context, index) {
                    final artist = state.artists[index];
                    return ArtistItemWidget(
                      artistImageURL: artist.image?.first.url ?? '',
                      artistName: artist.name ?? '',
                    );
                  },
                  itemCount: state.artists.length,
                ),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
