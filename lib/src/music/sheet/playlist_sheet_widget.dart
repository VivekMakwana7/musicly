import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicly/core/db/app_db.dart';
import 'package:musicly/core/db/models/song/db_song_model.dart';
import 'package:musicly/core/db/models/song_playlist/db_song_playlist_model.dart';
import 'package:musicly/core/di/injector.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';
import 'package:musicly/core/extensions/ext_string_alert.dart';
import 'package:musicly/src/music/sheet/music_sheet_widget.dart';
import 'package:musicly/widgets/app_button.dart';
import 'package:musicly/widgets/app_text_field.dart';
import 'package:musicly/widgets/network_image_widget.dart';

/// Playlist sheet widget
class PlaylistSheetWidget extends StatelessWidget {
  /// Default constructor
  const PlaylistSheetWidget({required this.song, super.key});

  /// For add Song into Playlist
  final DbSongModel song;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF353A40), Color(0xFF101010), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                spacing: 12.w,
                children: [
                  SizedBox.square(
                    dimension: 50.h,
                    child: ClipOval(child: NetworkImageWidget(url: song.image?.last.url ?? '')),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Text(
                            song.name ?? '',
                            maxLines: (song.label ?? '').isNotEmpty ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        if ((song.label ?? '').isNotEmpty)
                          Text(
                            song.label ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              for (final e in Injector.instance<AppDB>().songPlaylist) ...[
                MusicSheetMenu(
                  title: e.name,
                  onTap: () {
                    final model = e.copyWith(songs: [...e.songs, song]);
                    final list = Injector.instance<AppDB>().songPlaylist.toList();
                    list[list.indexWhere((element) => element.id == e.id)] = model;
                    Injector.instance<AppDB>().songPlaylist = list;
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 12.h),
              ],
              SizedBox(height: 30.h),
              AppButton(name: 'Add Playlist',onTap: () {
                Navigator.of(context).pop();
                AddPlaylistSheetWidget.show(context, song: song);
              },),
            ],
          ),
        ),
      ),
    );
  }

  /// For show sheet
  static void show(BuildContext context, {required DbSongModel song}) {
    showModalBottomSheet<dynamic>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (context) {
        return PlaylistSheetWidget(song: song);
      },
    );
  }
}

/// Add Playlist sheet widget
class AddPlaylistSheetWidget extends StatefulWidget {
  /// Default constructor
  const AddPlaylistSheetWidget({required this.song, super.key});

  /// For add song in created Playlist
  final DbSongModel song;

  @override
  State<AddPlaylistSheetWidget> createState() => _AddPlaylistSheetWidgetState();

  /// For show sheet
  static void show(BuildContext context, {required DbSongModel song}) {
    showModalBottomSheet<dynamic>(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (context) {
        return AddPlaylistSheetWidget(song: song);
      },
    );
  }
}

class _AddPlaylistSheetWidgetState extends State<AddPlaylistSheetWidget> {
  final _playlistController = TextEditingController();

  @override
  void dispose() {
    _playlistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.viewInsetsOf.bottom),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF353A40), Color(0xFF101010), Color(0xFF121212)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  spacing: 12.w,
                  children: [
                    SizedBox.square(
                      dimension: 50.h,
                      child: ClipOval(child: NetworkImageWidget(url: widget.song.image?.last.url ?? '')),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            child: Text(
                              widget.song.name ?? '',
                              maxLines: (widget.song.label ?? '').isNotEmpty ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                          if ((widget.song.label ?? '').isNotEmpty)
                            Text(
                              widget.song.label ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                AppTextField(controller: _playlistController, hintText: 'Enter a Playlist name'),
                SizedBox(height: 50.h),
                AppButton(
                  name: 'Add Playlist',
                  onTap: () {
                    final list = Injector.instance<AppDB>().songPlaylist.toList();
                    if (_playlistController.text.trim().isNotEmpty) {
                      if (!list.any((element) => element.name == _playlistController.text.trim())) {
                        final model = DbSongPlaylistModel(
                          name: _playlistController.text.trim(),
                          id: '${_playlistController.text.trim()[0]}${widget.song.id}',
                          image: widget.song.image?.last.url ?? '',
                          songs: [
                            ...[widget.song],
                          ],
                        );
                        list.add(model);
                        Injector.instance<AppDB>().songPlaylist = list;
                        Navigator.of(context).pop();
                        'Song added to playlist successfully'.showSuccessAlert();
                      } else {
                        'Please enter unique name of playlist'.showErrorAlert();
                      }
                    } else {
                      'Playlist name should not be empty'.showErrorAlert();
                    }
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
