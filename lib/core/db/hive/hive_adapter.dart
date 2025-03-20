import 'package:hive_ce/hive.dart';
import 'package:musicly/core/db/models/image_model.dart';
import 'package:musicly/core/db/models/recent_played_song_model.dart';
import 'package:musicly/core/db/models/search_history_model.dart';
import 'package:musicly/core/enums/search_item_type.dart';

part 'hive_adapter.g.dart';

@GenerateAdapters([
  AdapterSpec<SearchHistoryModel>(),
  AdapterSpec<ImageModel>(),
  AdapterSpec<SearchItemType>(),
  AdapterSpec<RecentPlayedSongModel>(),
])
// This is for code generation
// ignore: unused_element
void _() {}
