import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/extensions/ext_string.dart';
import 'package:musicly/core/logger.dart';
import 'package:musicly/src/album/album_detail/album_detail_page.dart';
import 'package:musicly/src/album/search_album_page.dart';
import 'package:musicly/src/artist/artist_detail/artist_detail_page.dart';
import 'package:musicly/src/artist/search_artist_page.dart';
import 'package:musicly/src/artist/song/artist_song_page.dart';
import 'package:musicly/src/home/home_page.dart';
import 'package:musicly/src/library/library_detail/library_detail_page.dart';
import 'package:musicly/src/library/library_page.dart';
import 'package:musicly/src/liked/liked_page.dart';
import 'package:musicly/src/music/music_page.dart';
import 'package:musicly/src/search/search_page.dart';
import 'package:musicly/src/search_playlist/playlist_detail/playlist_detail_page.dart';
import 'package:musicly/src/search_playlist/search_playlist_page.dart';
import 'package:musicly/src/song/search_song_page.dart';
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
    GoRoute(
      path: AppRoutes.searchAlbumPage.navPath,
      name: AppRoutes.searchAlbumPage,
      pageBuilder: (context, state) {
        final query = state.extra == null ? null : (state.extra! as Map<String, dynamic>)['query'] as String?;
        return MaterialPage(key: state.pageKey, child: SearchAlbumPage(query: query));
      },
    ),
    GoRoute(
      path: AppRoutes.searchArtistPage.navPath,
      name: AppRoutes.searchArtistPage,
      pageBuilder: (context, state) {
        final query = state.extra == null ? null : (state.extra! as Map<String, dynamic>)['query'] as String?;
        return MaterialPage(key: state.pageKey, child: SearchArtistPage(query: query));
      },
    ),
    GoRoute(
      path: AppRoutes.searchPlaylistPage.navPath,
      name: AppRoutes.searchPlaylistPage,
      pageBuilder: (context, state) {
        final query = state.extra == null ? null : (state.extra! as Map<String, dynamic>)['query'] as String?;
        return MaterialPage(key: state.pageKey, child: SearchPlaylistPage(query: query));
      },
    ),
    GoRoute(
      path: AppRoutes.albumDetailPage.navPath,
      name: AppRoutes.albumDetailPage,
      pageBuilder: (context, state) {
        final albumId = (state.extra! as Map<String, dynamic>)['albumId'] as String;
        return MaterialPage(key: state.pageKey, child: AlbumDetailPage(albumId: albumId));
      },
    ),
    GoRoute(
      path: AppRoutes.artistDetailPage.navPath,
      name: AppRoutes.artistDetailPage,
      pageBuilder: (context, state) {
        final artistId = (state.extra! as Map<String, dynamic>)['artistId'] as String;
        return MaterialPage(key: state.pageKey, child: ArtistDetailPage(artistId: artistId));
      },
    ),
    GoRoute(
      path: AppRoutes.playlistDetailPage.navPath,
      name: AppRoutes.playlistDetailPage,
      pageBuilder: (context, state) {
        final playlistId = (state.extra! as Map<String, dynamic>)['playlistId'] as String;
        return MaterialPage(key: state.pageKey, child: PlaylistDetailPage(playlistId: playlistId));
      },
    ),
    GoRoute(
      path: AppRoutes.musicPlayerPage.navPath,
      name: AppRoutes.musicPlayerPage,
      pageBuilder: (context, state) {
        return MaterialPage(key: state.pageKey, child: const MusicPage());
      },
    ),
    GoRoute(
      path: AppRoutes.libraryDetailPage.navPath,
      name: AppRoutes.libraryDetailPage,
      pageBuilder: (context, state) {
        final libraryId = (state.extra! as Map<String, dynamic>)['libraryId'] as String;
        return MaterialPage(key: state.pageKey, child: LibraryDetailPage(libraryId: libraryId));
      },
    ),
    GoRoute(
      path: AppRoutes.artistSongPage.navPath,
      name: AppRoutes.artistSongPage,
      pageBuilder: (context, state) {
        final artistId = (state.extra! as Map<String, dynamic>)['artistId'] as String;
        return MaterialPage(key: state.pageKey, child: ArtistSongPage(artistId: artistId));
      },
    ),
  ],
);
