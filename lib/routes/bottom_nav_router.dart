part of 'app_router.dart';

final _bottomNavBranches =
    BottomNavMenu.values
        .map(
          (e) => StatefulShellBranch(
            routes: [
              GoRoute(
                path: e.route.navPath,
                name: e.route,
                pageBuilder: (context, state) {
                  return MaterialPage(key: state.pageKey, child: e.child);
                },
              ),
            ],
          ),
        )
        .toList();
