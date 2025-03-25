import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/src/home/home_page.dart';
import 'package:musicly/src/library/library_page.dart';
import 'package:musicly/src/liked/liked_page.dart';
import 'package:musicly/src/search/pages/song/search_song_page.dart';
import 'package:musicly/src/search/search_page.dart';
import 'package:musicly/widgets/bottom_nav/bottom_nav.dart';

part 'app_routes.dart';
part 'bottom_nav_router.dart';

/// root navigation key
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Application router
final appRouter = GoRouter(
  navigatorKey: navKey,
  initialLocation: AppRoutes.initialLocation,
  redirect: (context, state) {
    'Full Path ${state.fullPath}'.logI;

    return null;
  },
  routes: [
    GoRoute(path: '/', pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const Scaffold())),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => BottomNav(child: navigationShell),
      branches: _bottomNavBranches,
    ),
    GoRoute(
      path: AppRoutes.searchSongPage.navPath,
      name: AppRoutes.searchSongPage,
      pageBuilder: (context, state) {
        final query = state.extra == null ? null : (state.extra! as Map<String, dynamic>)['query'] as String?;
        return MaterialPage(key: state.pageKey, child: SearchSongPage(query: query));
      },
    ),
  ],
);
