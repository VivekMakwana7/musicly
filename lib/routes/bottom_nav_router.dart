part of 'app_router.dart';

final _bottomNavBranches = <StatefulShellBranch>[
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.homePage.navPath,
        name: AppRoutes.homePage,
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const HomePage());
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.searchPage.navPath,
        name: AppRoutes.searchPage,
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const SearchPage());
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.libraryPage.navPath,
        name: AppRoutes.libraryPage,
        pageBuilder: (context, state) {
          final song = state.extra == null ? null : (state.extra! as Map<String, dynamic>)['song'] as DbSongModel?;
          return MaterialPage(key: state.pageKey, child: LibraryPage(song: song));
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.likedPage.navPath,
        name: AppRoutes.likedPage,
        pageBuilder: (context, state) {
          return MaterialPage(key: state.pageKey, child: const LikedPage());
        },
      ),
    ],
  ),
];
