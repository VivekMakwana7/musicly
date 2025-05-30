import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/gen/assets.gen.dart';
import 'package:musicly/routes/app_router.dart';
import 'package:musicly/src/download/download_page.dart';
import 'package:musicly/src/home/home_page.dart';
import 'package:musicly/src/library/library_page.dart';
import 'package:musicly/src/liked/liked_page.dart';
import 'package:musicly/src/search/search_page.dart';

/// Enum representing the different menu items in the bottom navigation bar
enum BottomNavMenu {
  /// [home] - Home screen menu item
  home,

  /// [search] - Search screen menu item
  search,

  /// [library] - Library screen menu item
  library,

  /// [liked] - Liked songs/content menu item
  liked,

  /// [download] - Download screen menu item
  download,
}

/// Extension on [BottomNavMenu] to provide additional functionality
/// for each menu item
///
/// Example usage:
/// ```dart
/// BottomNavMenu menu = BottomNavMenu.home;
/// bool isHome = menu.isHome; // true
/// ```
extension BottomNavMenuExtension on BottomNavMenu {
  /// Returns true if the current menu item is the home screen
  bool get isHome => this == BottomNavMenu.home;

  /// Returns true if the current menu item is the search screen
  bool get isSearch => this == BottomNavMenu.search;

  /// Returns true if the current menu item is the library screen
  bool get isLibrary => this == BottomNavMenu.library;

  /// Returns true if the current menu item is the liked songs/content screen
  bool get isLiked => this == BottomNavMenu.liked;

  /// Returns true if the current menu item is the download screen
  bool get isDownload => this == BottomNavMenu.download;

  /// Returns the appropriate icon widget based on the menu item
  Widget get icon {
    return switch (this) {
      BottomNavMenu.home => Assets.icons.icHome.svg(key: const ValueKey('home-un-selected'), height: 20.h, width: 20.h),
      BottomNavMenu.search => Assets.icons.icSearch.svg(
        key: const ValueKey('search-un-selected'),
        height: 20.h,
        width: 20.h,
      ),
      BottomNavMenu.library => Assets.icons.icPlayList.svg(
        key: const ValueKey('library-un-selected'),
        height: 20.h,
        width: 20.h,
      ),
      BottomNavMenu.liked => Assets.icons.icHeart.svg(
        key: const ValueKey('liked-un-selected'),
        height: 20.h,
        width: 20.h,
      ),
      BottomNavMenu.download => Assets.icons.icDownload.svg(
        key: const ValueKey('download-un-selected'),
        height: 20.h,
        width: 20.h,
      ),
    };
  }

  /// Returns the appropriate selected icon widget based on the menu item
  Widget get selectedIcon {
    return switch (this) {
      BottomNavMenu.home => Assets.icons.icHome.svg(
        key: const ValueKey('home-selected'),
        height: 20.h,
        width: 20.h,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      BottomNavMenu.search => Assets.icons.icSearch.svg(
        key: const ValueKey('search-selected'),
        height: 20.h,
        width: 20.h,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      BottomNavMenu.library => Assets.icons.icPlayList.svg(
        key: const ValueKey('library-selected'),
        height: 20.h,
        width: 20.h,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      BottomNavMenu.liked => Assets.icons.icHeart.svg(
        key: const ValueKey('liked-selected'),
        height: 20.h,
        width: 20.h,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      BottomNavMenu.download => Assets.icons.icDownload.svg(
        key: const ValueKey('download-selected'),
        height: 20.h,
        width: 20.h,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    };
  }

  /// Returns the route associated with the menu item
  String get route {
    return switch (this) {
      BottomNavMenu.home => AppRoutes.homePage,
      BottomNavMenu.search => AppRoutes.searchPage,
      BottomNavMenu.library => AppRoutes.libraryPage,
      BottomNavMenu.liked => AppRoutes.likedPage,
      BottomNavMenu.download => AppRoutes.downloadPage,
    };
  }

  /// Returns the child widget associated with the menu item
  Widget get child {
    return switch (this) {
      BottomNavMenu.home => const HomePage(),
      BottomNavMenu.search => const SearchPage(),
      BottomNavMenu.library => const LibraryPage(),
      BottomNavMenu.liked => const LikedPage(),
      BottomNavMenu.download => const DownloadPage(),
    };
  }
}
